require 'open-uri'

namespace :scrap do
  desc "TODO"
  task fujixweekly: :environment do
    slug = ENV.fetch('SLUG')
    sensor = Sensor.find_by!(slug: ENV.fetch('SENSOR'))
    doc = Nokogiri::HTML(URI.open("https://fujixweekly.com/#{slug}/"))
    user = User.find_by!(username: ENV['USERNAME'])

    doc.css('img.wp-block-cover__image-background').each do |cover_image|
      parent = cover_image.parent
      poster_url = URI.parse(cover_image['src'])
      name = parent.text.strip
      url = URI.parse(parent.css('a').first['href'])
      date_matches = url.to_s.match(/\S\.com\/(?<year>\d+)\/(?<month>\d+)\/(?<day>\d+)\/\S/)
      created_at = Date.new(date_matches[:year].to_i, date_matches[:month].to_i, date_matches[:day].to_i)

      if Recipe.find_by(original_url: url.to_s)
        puts "Recipe for #{name} already exists"
        next
      end

      recipe = Recipe.source_type_external.new(
        name: name,
        sensor: sensor,
        user: user,
        original_author: 'Fuji X Weekly',
        original_url: url,
        created_at: created_at
      )

      recipe.poster.attach(
        io: StringIO.new(Faraday.get(poster_url).body),
        filename: poster_url.path.split('/').last
      )
      recipe.save!

      puts "Recipe #{recipe.name} saved"
    end
  end
end
