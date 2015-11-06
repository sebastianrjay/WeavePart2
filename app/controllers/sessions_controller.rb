class SessionsController < ApplicationController

  def new; end

  def create
    omniauth_info = request.env['omniauth.auth']['info']
    credentials = request.env['omniauth.auth']['credentials']
    cookies[:gmail_token] = credentials['token']
    cookies[:expires_at] = credentials['expires_at']
    user = User.find_by_gmail_address(omniauth_info['email'])

    if user && credentials['refresh_token']
      user.update(
        gmail_token: credentials['token'],
        gmail_refresh_token: credentials['refresh_token']
      )
    elsif user # Supposedly Gmail sends refresh_token only once; I didn't check.
      user.update(gmail_token: credentials['token'])
    else
      User.create(
        gmail_address: omniauth_info['email'],
        first_name: omniauth_info['first_name'],
        last_name: omniauth_info['last_name'],
        gmail_token: credentials['token'],
        gmail_refresh_token: credentials['refresh_token']
      )
    end

    redirect_to root_url
  end
end
