# frozen_string_literal: true

require 'rails_helper'
require 'line/bot'
require 'webmock/rspec'

REQUEST_TEXT = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "replyToken": 'nHuyWiB7yP5Zw52FIkcQobQuGDXCTA',
      "type": 'message',
      "mode": 'active',
      "timestamp": 1_462_629_479_859,
      "source": {
        "type": 'user',
        "userId": 'U91eeaf62d...'
      },
      "message": {
        "id": '325708',
        "type": 'text',
        "text": 'Hello, world!'
      }
    }
  ]
}.freeze

REQUEST_IMAGE = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "replyToken": 'nHuyWiB7yP5Zw52FIkcQobQuGDXCTA',
      "type": 'message',
      "mode": 'active',
      "timestamp": 1_462_629_479_859,
      "source": {
        "type": 'user',
        "userId": 'U91eeaf62d...'
      },
      "message": {
        "id": '325708',
        "type": 'image',
        "contentProvider": {
          "type": 'line'
        }
      }
    }
  ]
}.freeze

REQUEST_POSTBACK_ACCOUNT_LINK_DESTROY_CONFIRMATION = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "type": 'postback',
      "replyToken": 'b60d432864f44d079f6d8efe86cf404b',
      "source": {
        "userId": 'U91eeaf62d...',
        "type": 'user'
      },
      "mode": 'active',
      "timestamp": 1_513_669_370_317,
      "postback": {
        "data": 'accountlink_destroy_confirmation',
        "params": {
          "datetime": '2017-12-25T01:00'
        }
      }
    }
  ]
}.freeze

REQUEST_POSTBACK_ACCOUNT_LINK_DESTROY = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "type": 'postback',
      "replyToken": 'b60d432864f44d079f6d8efe86cf404b',
      "source": {
        "userId": 'U91eeaf62d...',
        "type": 'user'
      },
      "mode": 'active',
      "timestamp": 1_513_669_370_317,
      "postback": {
        "data": 'accountlink_destroy',
        "params": {
          "datetime": '2017-12-25T01:00'
        }
      }
    }
  ]
}.freeze

REQUEST_POSTBACK_ACCOUNT_LINK_CREATE = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "type": 'postback',
      "replyToken": 'b60d432864f44d079f6d8efe86cf404b',
      "source": {
        "userId": 'U91eeaf62d...',
        "type": 'user'
      },
      "mode": 'active',
      "timestamp": 1_513_669_370_317,
      "postback": {
        "data": 'accountlink_create',
        "params": {
          "datetime": '2017-12-25T01:00'
        }
      }
    }
  ]
}.freeze

REQUEST_ACCOUNT_LINK = {
  "destination": 'xxxxxxxxxx',
  "events": [
    {
      "type": 'accountLink',
      "mode": 'active',
      "replyToken": 'b60d432864f44d079f6d8efe86cf404b',
      "source": {
        "userId": 'U91eeaf62d...',
        "type": 'user'
      },
      "timestamp": 1_513_669_370_317,
      "link": {
        "result": 'ok',
        "nonce": 'xxx'
      }
    }
  ]
}.freeze

PARAMS_NEW = {
  'linkToken' => 'xxxxxxxxxxxx',
  'user_id' => '1'
}.freeze

LINE_BOT_REPLY_URL = Line::Bot::API::DEFAULT_ENDPOINT + '/bot/message/reply'
LINE_BOT_REPLY_RICH_MENU_CREATE_URL = Line::Bot::API::DEFAULT_ENDPOINT + \
                                      '/bot/user/U91eeaf62d.../richmenu/' + ENV['RICH_MENU_FOR_UNLINKED_USER']
LINE_BOT_REPLY_RICH_MENU_DESTROY_URL = Line::Bot::API::DEFAULT_ENDPOINT + \
                                       '/bot/user/U91eeaf62d.../richmenu/' + ENV['RICH_MENU_FOR_LINKED_USER']
CREATE_LINK_TOKEN_URL = Line::Bot::API::DEFAULT_ENDPOINT + \
                        '/bot/user/U91eeaf62d.../linkToken'
GET_CONTENT_URL = 'https://api-data.line.me/v2/bot/message/325708/content'
RSpec.describe 'Linebots', type: :request do
  let(:user) { create(:user) }

  describe 'post /callback' do
    before do
      allow_any_instance_of(Line::Bot::Client).to receive(:validate_signature).and_return(true)
      stub_request(:post, LINE_BOT_REPLY_URL)
        .to_return(status: 200, body: '')
    end
    it 'requests message text' do
      post '/callback', params: REQUEST_TEXT, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'requests message image' do
      post '/callback', params: REQUEST_IMAGE, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'requests postback account link destroy confirmation' do
      post '/callback',
           params: REQUEST_POSTBACK_ACCOUNT_LINK_DESTROY_CONFIRMATION, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'requests postback account link destroy' do
      stub_request(:post, LINE_BOT_REPLY_RICH_MENU_CREATE_URL)
        .to_return(status: 200, body: '')
      post '/callback',
           params: REQUEST_POSTBACK_ACCOUNT_LINK_DESTROY, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'requests postback account link create' do
      stub_request(:post, CREATE_LINK_TOKEN_URL)
        .to_return(status: 200, body: '')
      post '/callback',
           params: REQUEST_POSTBACK_ACCOUNT_LINK_CREATE, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'requests account link' do
      stub_request(:post, LINE_BOT_REPLY_RICH_MENU_DESTROY_URL)
        .to_return(status: 200, body: '')
      allow(Rails).to receive_message_chain('cache.read').and_return(user.id)
      post '/callback',
           params: REQUEST_ACCOUNT_LINK, as: :json
      expect(response).to have_http_status(:success)
    end

    describe 'the line user who has created account link' do
      before do
        create(:line_bot, user: user)
      end

      it 'requests message text' do
        stub_request(:post, LINE_BOT_REPLY_RICH_MENU_DESTROY_URL)
          .to_return(status: 200, body: '')
        post '/callback', params: REQUEST_TEXT, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'requests message image' do
        stub_request(:get, GET_CONTENT_URL).to_return(status: 200, body: '')
        allow_any_instance_of(Avatar).to receive(:generate).and_return('')
        expect do
          post '/callback', params: REQUEST_IMAGE, as: :json
        end.to change(user.avatars, :count).by(1)
        expect(response).to have_http_status(:success)
      end

      it 'requests postback account link destroy' do
        stub_request(:post, LINE_BOT_REPLY_RICH_MENU_CREATE_URL)
          .to_return(status: 200, body: '')
        expect do
          post '/callback',
               params: REQUEST_POSTBACK_ACCOUNT_LINK_DESTROY, as: :json
        end.to change(LineBot.all, :count).by(-1)
        expect(response).to have_http_status(:success)
      end

      it 'requests postback account link create' do
        stub_request(:post, LINE_BOT_REPLY_RICH_MENU_DESTROY_URL)
          .to_return(status: 200, body: '')
        post '/callback',
             params: REQUEST_POSTBACK_ACCOUNT_LINK_CREATE, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    describe 'invalid user' do
      it 'fail to create account link' do
        allow(Rails).to receive_message_chain('cache.read').and_return('')
        post '/callback',
             params: REQUEST_ACCOUNT_LINK, as: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  it 'requests new ' do
    allow(Rails).to receive_message_chain('cache.write').and_return('')
    get new_line_bot_path, params: PARAMS_NEW
    expect(response).to have_http_status(:success)
  end
end
