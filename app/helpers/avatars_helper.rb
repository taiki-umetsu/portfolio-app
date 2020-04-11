# frozen_string_literal: true

module AvatarsHelper
  def face_coordinate(photo)
    credentials = Aws::Credentials.new(
      ENV['RTB_ACCESS_KEY'],
      ENV['RTB_SECRET_KEY']
    )
    client = Aws::Rekognition::Client.new credentials: credentials
    attrs = {
      image: {
        bytes: photo
      },
      attributes: ['ALL']
    }
    eye_left_ratio = { x: 0, y: 0 }
    eye_right_ratio = { x: 0, y: 0 }
    nose_ratio = { x: 0, y: 0 }

    response = client.detect_faces attrs
    puts 'Detected faces for: '
    response.face_details.each do |face_detail|
      eye_left_ratio = { x: face_detail.landmarks[0].x,
                         y: face_detail.landmarks[0].y }
      eye_right_ratio = { x: face_detail.landmarks[1].x,
                          y: face_detail.landmarks[1].y }
      nose_ratio = { x: face_detail.landmarks[4].x,
                     y: face_detail.landmarks[4].y }
    end
    puts eye_left_ratio
    puts eye_right_ratio
    puts nose_ratio
  end
end
