require 'open-uri'

module Scrappers
  class IvanYoloScrapper
    def initialize(username:, logger: Rails.logger)
      @logger = logger
      @user = User.find_by!(username: username)
    end

    def call
      sensor = Sensor.find_by!(slug: 'xtrans4')
      doc = Nokogiri::HTML(URI.open("https://www.ivanyolo.com/fujifilm-recipes/"))

      doc.at('a:contains("Fujifilm X-Trans IV Recipes")').parent.css('ul.sub-menu').first.css('a.elementor-sub-item').each do |link|
        name = link.text.strip
        url = link['href']

        if Recipe.find_by(original_url: url.to_s)
          logger.info "Recipe for #{name} already exists"
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

        logger.info "Recipe #{recipe.name} saved"
      end

      true
    end

    private

    attr_reader :logger, :user
  end
end
