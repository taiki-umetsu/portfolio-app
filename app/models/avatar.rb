# frozen_string_literal: true

class Avatar < ApplicationRecord
  require 'matrix'
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  NOSE_MODEL = Vector[151.16, 284.21]
  DIMENSION_AFTER_TRIM = Vector[360, 640]
  EYE_DISTANCE_MODEL = 90.16
  AVATAR_FILE_NAME = {
    exist_in_s3: ['astronaut.gltf', 'astronaut.bin', 'astronaut.png'],
    need_to_create: 'texture_face.png'
  }.freeze

  def generate(image)
    face = DetectFace.new(image)
    calculate = Calculate.new(
      face.angle, face.nose, face.scaling_rate, face.dimension_original_image
    )
    distance = calculate.distance_between_model_and_user_nose
    trimed_image = triming(face.image, face.scaling_rate, face.angle, distance)
    Ready3dFiles.new(id, trimed_image)
  end

  def destroy_s3_file
    @bucket = 'avatar.portfolio'
    client_s3 = Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    client_s3.delete_objects({
                               bucket: @bucket,
                               delete: {
                                 objects: [
                                   { key: "avatar/#{id}/astronaut.gltf" },
                                   { key: "avatar/#{id}/astronaut.bin" },
                                   { key: "avatar/#{id}/astronaut.png" },
                                   { key: "avatar/#{id}/texture_face.png" }
                                 ],
                                 quiet: false
                               }
                             })
  end

  class DetectFace
    attr_reader :image
    def initialize(image_bytes)
      credentials = Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY'],
        ENV['AWS_SECRET_KEY']
      )
      client = Aws::Rekognition::Client.new credentials: credentials
      attrs = {
        image: {
          bytes: image_bytes
        },
        attributes: ['ALL']
      }
      response = client.detect_faces attrs
      response.face_details.each do |face_detail|
        @eye_left_ratio = Vector[face_detail.landmarks[0].x,
                                 face_detail.landmarks[0].y]
        @eye_right_ratio = Vector[face_detail.landmarks[1].x,
                                  face_detail.landmarks[1].y]
        @nose_ratio = Vector[face_detail.landmarks[4].x,
                             face_detail.landmarks[4].y]
      end
      @image = MiniMagick::Image.read(image_bytes)
    end

    def dimension_original_image
      Vector[@image[:width], @image[:height]]
    end

    def nose
      # vector_a.map2(vector_b) {|a, b| a*b } -> Vector[a0*b0, a1*b1]
      @nose_ratio.map2(dimension_original_image) do |a, b|
        (a * b).round(2)
      end
    end

    def scaling_rate
      eye_distance_user = Math.sqrt(diff_eye[0]**2 + diff_eye[1]**2).round(2)
      (EYE_DISTANCE_MODEL / eye_distance_user).round(4)
    end

    def angle
      angle = -(Math.atan2(diff_eye[1], diff_eye[0]) * (180 / Math::PI)).round(5)
      # convert (angle < 0, 360 < angle) to (0 <= angle <=360)
      (angle % 360).round(5)
    end

    private

    def diff_eye
      eye_left = @eye_left_ratio.map2(dimension_original_image) do |a, b|
        (a * b).round(2)
      end
      eye_right = @eye_right_ratio.map2(dimension_original_image) do |a, b|
        (a * b).round(2)
      end
      eye_right.map2(eye_left) { |a, b| a - b }
    end
  end

  class Calculate
    def initialize(angle, nose, scaling_rate, dimension_original_image)
      @angle = angle
      @angle_radian = angle * (Math::PI / 180).round(5)
      @nose = nose
      @scaling_rate = scaling_rate
      @dimension_original_image = dimension_original_image
    end

    def distance_between_model_and_user_nose
      rotation = Matrix[[cos, -sin], [sin, cos]]
      center_of_image = @dimension_original_image.map { |a| a / 2 }
      coordinate_transformation = \
        dimension_after_rotated.map2(@dimension_original_image) { |a, b| 0.5 * (a - b) }
      nose_coordinates_variation_by_rotation_and_scaling = \
        (rotation * (@nose - center_of_image) \
        + center_of_image + coordinate_transformation \
        ).*(@scaling_rate)
      NOSE_MODEL.map2(nose_coordinates_variation_by_rotation_and_scaling) do |a, b|
        (a - b).round(2)
      end
    end

    private

    def cos
      Math.cos(@angle_radian).round(5)
    end

    def sin
      Math.sin(@angle_radian).round(5)
    end

    def dimension_after_rotated
      if @angle >= 0 && @angle < 90
        cs = Matrix[[cos, sin], [sin, cos]]
      elsif @angle >= 90 && @angle < 180
        cs = Matrix[[-cos, sin], [sin, -cos]]
      elsif @angle >= 180 && @angle < 270
        cs = Matrix[[-cos, -sin], [-sin, -cos]]
      elsif @angle >= 270 && @angle < 360
        cs = Matrix[[cos, -sin], [-sin, cos]]
      end
      cs * @dimension_original_image
    end
  end

  def triming(image, scaling_rate, angle, distance)
    srt = [
      '0, 0',
      scaling_rate,
      0,
      "#{distance[0]}, #{distance[1]} "
    ].join(' ')
    image.mogrify do |convert|
      convert.background('black')
      convert.virtual_pixel('background')
      convert.rotate(angle)
      convert.distort(:SRT, srt)
      convert.crop("#{DIMENSION_AFTER_TRIM[0]}x#{DIMENSION_AFTER_TRIM[1]}+0+0")
      convert.draw 'line 0,284 360,284'
      convert.draw 'line 151,0 151,640'
      # save to temporary file , not to local file
      @temp = Tempfile.new
      convert.write(@temp.path)
    end
    @temp
  end

  class Ready3dFiles
    def initialize(id, trimed_image)
      @client_s3 = Aws::S3::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY']
      )
      @trimed_image = trimed_image
      @bucket = 'avatar.portfolio'
      @id = id
      upload_texture
      authorize_read_access(AVATAR_FILE_NAME[:need_to_create])
      AVATAR_FILE_NAME[:exist_in_s3].each do |f|
        copy(f)
        authorize_read_access(f)
      end
    end

    def upload_texture
      texture = AVATAR_FILE_NAME[:need_to_create]
      @client_s3.put_object(
        bucket: @bucket,
        key: "avatar/#{@id}/#{texture}",
        body: @trimed_image.read
      )
    end

    def copy(file_name)
      source_key = "avatar/0/#{file_name}"
      target_key = "avatar/#{@id}/#{file_name}"
      begin
        @client_s3.copy_object(
          bucket: @bucket,
          copy_source: @bucket + '/' + source_key,
          key: target_key
        )
      rescue StandardError => e
        puts 'Caught exception copying object ' + source_key + ' from bucket ' \
         + @bucket + ' to bucket ' + @bucket + ' as ' + target_key + ':'
        puts e.message
      end
    end

    def authorize_read_access(file_name)
      target_key = "avatar/#{@id}/#{file_name}"
      @client_s3.put_object_acl({
                                  acl: 'public-read',
                                  bucket: @bucket,
                                  key: target_key
                                })
    end
  end
end
