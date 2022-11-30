require 'open-uri'

class CallbacksController < Devise::OmniauthCallbacksController
  def reddit
    uid = request.env['omniauth.auth']['uid']
    username = request.env['omniauth.auth']['info']['name']
    avatar_url = request.env['omniauth.auth']['extra']['raw_info']['icon_img']

    user = User.where(reddit_uid: uid).first_or_create do |u|
      u.email = "#{SecureRandom.uuid}@example.com"
      u.password = SecureRandom.hex
      u.username = username

      if avatar_url.present?
        u.avatar.attach(io: StringIO.new(Faraday.get(avatar_url).body), filename: avatar_url.split('/').last)
      end
    end

    sign_in_and_redirect user
  end
end
