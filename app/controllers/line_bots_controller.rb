# frozen_string_literal: true

class LineBotsController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    events = ready(request)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          response_for_text_message(event)
        when Line::Bot::Event::MessageType::Image
          response_for_image_massage(event)
        end
      when Line::Bot::Event::Postback
        case event['postback']['data']
        when 'accountlink_destroy_confirmation'
          reply(event, ACCOUNT_LINK_DESTROY_CONFIRMATION)
        when 'accountlink_destroy'
          response_for_account_link_destroy(event)
        when 'accountlink_create'
          response_for_account_link_create(event)
        end
      when Line::Bot::Event::AccountLink
        response_for_account_link(event)
      end
    end
    # Don't forget to return a successful response
    'OK'
  end

  def new
    @nonce = SecureRandom.urlsafe_base64
    @link_token = params['linkToken']
    user_id = params['user_id']
    Rails.cache.write("line_nonce:#{@nonce}", user_id, expires_in: 1.minute)
  end

  private

  def ready(request)
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    error 400 do 'Bad Request' end unless client.validate_signature(body, signature)
    client.parse_events_from(body)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_id = ENV['LINE_CHANNEL_ID']
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def response_for_text_message(event)
    text = linked?(event) ? SEND_FACE_IMAGE : CREATE_ACCOUNT_LINK
    reply(event, message(text))
    reply_richmenu(event, richmenu_for_linked_uesr) if linked?(event)
  end

  def response_for_image_massage(event)
    text = linked?(event) ? url_for_avatar(event) : CREATE_ACCOUNT_LINK
    reply(event, message(text))
  end

  def response_for_account_link_destroy(event)
    text = linked?(event) ? SUCCESS : NO_ACCOUNT_LINK
    account_link_destroy(event) if linked?(event)
    reply(event, message(text))
    reply_richmenu(event, richmenu_for_unlinked_uesr)
  end

  def response_for_account_link_create(event)
    message = linked?(event) ? message(ALREADY_LINKED) : signup_url(event)
    reply(event, message)
    reply_richmenu(event, richmenu_for_linked_uesr) if linked?(event)
  end

  def response_for_account_link(event)
    text = valid_user?(event) ? create_account_link(event) : FAIL_TO_LINK
    reply(event, message(text))
  end

  def valid_user?(event)
    line_user_id(event) && nonce(event)
  end

  def line_user_id(event)
    event['source']['type'] == 'user' && event['source']['userId']
  end

  def nonce(event)
    event['link']['result'] == 'ok' && event['link']['nonce']
  end

  def create_account_link(event)
    user_id = Rails.cache.read("line_nonce:#{nonce(event)}")
    account_link = LineBot.new(user_id: user_id, line_user_id: line_user_id(event))
    reply_richmenu(event, richmenu_for_linked_uesr) if account_link.save
    account_link.save ? SUCCESS_TO_LINK : FAIL_TO_LINK
  end

  def richmenu_for_unlinked_uesr
    ENV['RICH_MENU_FOR_UNLINKED_USER']
  end

  def richmenu_for_linked_uesr
    ENV['RICH_MENU_FOR_LINKED_USER']
  end

  def reply(event, message)
    client.reply_message(event['replyToken'], message)
  end

  def reply_richmenu(event, richmenu_id)
    client.link_user_rich_menu(line_user_id(event), richmenu_id)
  end

  def find_line_user(event)
    LineBot.find_by(line_user_id: line_user_id(event))
  end

  def linked?(event)
    find_line_user(event).present?
  end

  def message(text)
    { type: 'text', text: text }
  end

  def url_for_avatar(event)
    account_link = find_line_user(event)
    response = client.get_message_content(event.message['id'])
    avatar = Avatar.new(user_id: account_link.user_id)
    avatar.save!
    avatar.generate(response.body)
    avatar_url(avatar)
  end

  def account_link_destroy(event)
    account_link = find_line_user(event)
    account_link.destroy!
  end

  def signup_url(event)
    token = client.create_link_token(line_user_id(event)).body[14..-3]
    signup_or_login_to_create_link(token)
  end

  def signup_or_login_to_create_link(token)
    {
      type: 'template',
      altText: 'accountlink_create',
      template: {
        type: 'buttons',
        title: 'アカウント連携',
        text: 'サインアップまたはログインしてください',
        actions: [
          {
            "type": 'uri',
            "label": 'Sign up',
            "uri": "https://www.kaoreal.com/users/sign_up?linkToken=#{token}"
          },
          {
            "type": 'uri',
            "label": 'Log in',
            "uri": "https://www.kaoreal.com/users/sign_in?linkToken=#{token}"
          }
        ]
      }
    }
  end

  ACCOUNT_LINK_DESTROY_CONFIRMATION = {
    type: 'template',
    altText: 'accountlink_destroy_confirmation',
    template: {
      type: 'buttons',
      title: '確認',
      text: 'アカウント連携を解除しますか？',
      actions: [
        {
          type: 'postback',
          label: 'YES',
          data: 'accountlink_destroy'
        }
      ]
    }
  }.freeze

  CREATE_ACCOUNT_LINK = 'カオリアルのアカウントとLineアカウントの連携をしてください'
  SEND_FACE_IMAGE = '顔画像を送ってみてね！'
  SUCCESS = 'アカウント連携を解除しました'
  NO_ACCOUNT_LINK = 'アカウント連携していません'
  ALREADY_LINKED = '連携済みです！顔画像を送ってみてね'
  SUCCESS_TO_LINK = 'アカウントを連携しました!顔画像を送ってみてね！'
  FAIL_TO_LINK = 'アカウントを連携できませんでした'
end
