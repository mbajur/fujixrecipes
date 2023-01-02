require 'open-uri'

module Scrappers
  class CaptnLookScrapper
    def initialize(username:, logger: Rails.logger)
      @logger = logger
      @user = User.find_by!(username: username)
    end

    def call
      sensor = Sensor.find_by!(slug: 'xtrans4')
      doc = Nokogiri::HTML(URI.open('https://www.captnlook.com/'))

      doc.css('span:contains("View Recipe")').each do |link|
        url = link.parent['href'].to_s

        if Recipe.find_by(original_url: url)
          logger.info "Recipe for #{url} already exists"
          next
        end

        recipe_doc = Nokogiri::HTML(URI.open(url))
        name = recipe_doc.at('h1.font_2').text.titleize
        sensor = sensor
        original_url = url
        year = recipe_doc.at('p.font_7:contains("YEAR")').parent.next_element.text
        created_at = DateTime.parse("1-1-#{year}").beginning_of_year
        poster_url = recipe_doc.at('img.gallery-item-visible').parent.at('source[type="image/jpeg"]')['srcset'].match(/(?<uri>https:\/\/\S+)\ 5x/)[:uri]

        recipe = Recipe.source_type_external.new(
          name: name.titleize,
          sensor: sensor,
          user: user,
          original_author: 'captn.look',
          original_url: original_url,
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
