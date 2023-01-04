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

      doc.at('h1:contains("Fujifilm Recipes: X-Trans IV Film Simulation Recipes")').ancestors('section')[0].next_element.css('.elementor-tab-content a').each do |link|
        name = link.text.strip

        url = ['https://www.ivanyolo.com']
        url << '/' unless link['href'].starts_with?('/')
        url << link['href']
        url = url.join('')

        if Recipe.find_by(original_url: url.to_s)
          pp "Recipe for #{name} already exists"
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

        pp "Recipe #{recipe.name} saved"
      end

      true
    end

    private

    attr_reader :logger, :user
  end
end
