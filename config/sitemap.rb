# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://fujixrecipes.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  Camera.find_each do |camera|
    add camera_path(camera), priority: 0.9, changefreq: 'daily'
  end

  Sensor.find_each do |sensor|
    add sensor_path(sensor), priority: 0.8, changefreq: 'daily'
  end

  User.find_each do |user|
    add user_path(user), priority: 0.7, changefreq: 'daily'
  end
end
