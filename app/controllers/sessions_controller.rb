class SessionsController < ApplicationController

  def new; end

  def create
    omniauth_info = request.env['omniauth.auth']['info']
    credentials = request.env['omniauth.auth']['credentials']
    cookies[:access_token] = credentials['token']
    cookies[:expires_at] = credentials['expires_at']
    user = User.find_by_gmail_address(omniauth_info['email'])

    if user
      user.update(access_token: credentials['token'])
    else
      User.create(
        gmail_address: omniauth_info['email'],
        first_name: omniauth_info['first_name'],
        last_name: omniauth_info['last_name'],
        access_token: credentials['token']
      )
    end

    puts "SessionsController access token:"
    puts cookies[:access_token]
    puts "SessionsController expires_at:"
    puts cookies[:expires_at].to_s

    redirect_to root_url
  end
end
