require 'open-uri'

module Scrappers
  class FilmRecipesScrapper
    def initialize(username:, logger: Rails.logger)
      @logger = logger
      @user = User.find_by!(username: username)
    end

    def call
      sensor = Sensor.find_by!(slug: 'xtrans4')
      doc = Nokogiri::HTML(URI.open("https://film.recipes/blog/film-recipes-index-a-z/"))

      doc.css('.wp-block-cover__inner-container').each do |cover_image|
        name = cover_image.text.strip
        url = cover_image.css('a').first['href']
        date_matches = url.to_s.match(/\S\.recipes\/(?<year>\d+)\/(?<month>\d+)\/(?<day>\d+)\/\S/)
        created_at = Date.new(date_matches[:year].to_i, date_matches[:month].to_i, date_matches[:day].to_i)
        poster_url = cover_image.parent.css('img.wp-block-cover__image-background').first['src']

        if Recipe.find_by(original_url: url.to_s)
          logger.info "Recipe for #{name} already exists"
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

        logger.info "Recipe #{recipe.name} saved"
      end
    end

    private

    attr_reader :logger, :user
  end
end
