require 'open-uri'

namespace :scrap do
  desc "TODO"
  task fujixweekly: :environment do
    Scrappers::FujiWeeklyScrapper.new(slug: ENV.fetch('SLUG'), sensor: ENV.fetch('SENSOR'), username: ENV['USERNAME']).call
  end

  desc "TODO"
  task ivanyolo: :environment do
    Scrappers::IvanYoloScrapper.new(username: ENV['USERNAME']).call
  end

  desc "TODO"
  task filmrecipes: :environment do
    Scrappers::FilmRecipesScrapper.new(username: ENV['USERNAME']).call
  end
end
