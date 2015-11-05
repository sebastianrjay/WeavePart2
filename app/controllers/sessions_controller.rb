class SessionsController < ApplicationController
  layout false

  def new; end

  def create
    @request_env = request.env
    @auth = request.env['omniauth.auth']['credentials']
    GmailOauth.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime
    )
  end
end