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

  desc "TODO"
  task ivanyolo: :environment do
    sensor = Sensor.find_by!(slug: 'xtrans4')
    doc = Nokogiri::HTML(URI.open("https://www.ivanyolo.com/fujifilm-recipes/"))
    user = User.find_by!(username: ENV['USERNAME'])

    doc.at('a:contains("Fujifilm X-Trans IV Recipes")').parent.css('ul.sub-menu').first.css('a.elementor-sub-item').each do |link|
      name = link.text.strip
      url = link['href']

      if Recipe.find_by(original_url: url.to_s)
        puts "Recipe for #{name} already exists"
        next
      end

      recipe_doc = Nokogiri::HTML(URI.open(url))
      created_at = recipe_doc.css('meta[property="article:published_time"]').first['content']
      poster_url = recipe_doc.css('meta[property="og:image"]').first['content']

      recipe = Recipe.source_type_external.new(
        name: name,
        sensor: sensor,
        user: user,
        original_author: 'Ivan Yolo',
        original_url: url,
        created_at: created_at
      )

      recipe.poster.attach(
        io: StringIO.new(Faraday.get(poster_url).body),
        filename: 'poster.jpg'
      )
      recipe.save!

      puts "Recipe #{recipe.name} saved"
    end
  end

  desc "TODO"
  task filmrecipes: :environment do
    sensor = Sensor.find_by!(slug: 'xtrans4')
    doc = Nokogiri::HTML(URI.open("https://film.recipes/blog/film-recipes-index-a-z/"))
    user = User.find_by!(username: ENV['USERNAME'])

    doc.css('.wp-block-cover__inner-container').each do |cover_image|
      name = cover_image.text.strip
      url = cover_image.css('a').first['href']
      date_matches = url.to_s.match(/\S\.recipes\/(?<year>\d+)\/(?<month>\d+)\/(?<day>\d+)\/\S/)
      created_at = Date.new(date_matches[:year].to_i, date_matches[:month].to_i, date_matches[:day].to_i)
      poster_url = cover_image.parent.css('img.wp-block-cover__image-background').first['src']

      if Recipe.find_by(original_url: url.to_s)
        puts "Recipe for #{name} already exists"
        next
      end

      recipe = Recipe.source_type_external.new(
        name: name,
        sensor: sensor,
        user: user,
        original_author: 'film.recipes',
        original_url: url,
        created_at: created_at
      )

      recipe.poster.attach(
        io: StringIO.new(Faraday.get(poster_url).body),
        filename: 'poster.jpg'
      )
      recipe.save!

      puts "Recipe #{recipe.name} saved"
    end
  end
end
