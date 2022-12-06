module UsersHelper
  def avatar_url(user, width = 30, height = 30)
    if user.avatar.attached?
      user.avatar.representation(resize_to_fill: [width, height])
    else
      hash = Digest::MD5.hexdigest(user.email)
      "https://www.gravatar.com/avatar/#{hash}?s=#{width}&d=mp"
    end
  end
end
