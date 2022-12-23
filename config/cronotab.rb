# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
# Crono.perform(TestJob).every 2.days, at: '15:30'
#

class CleanupOldCronoJobsJob
  def perform
    Crono::CronoJob.where('created_at < ?', 2.weeks.ago).destroy_all
  end
end

class CalculateRecipesCountForCamerasJob
  def perform
    Camera.all.each do |camera|
      camera.update(recipes_count: Recipe.joins(:sensor).where('sensors.slug': Sensor.compatibility_matrix[camera.sensor.slug.to_sym]).count)
    end
  end
end

class IvanYoloScrapJob
  def perform
    Scrappers::IvanYoloScrapper.new(username: ENV.fetch('IVAN_YOLO_SCRAPPER_USERNAME'), logger: Crono.logger).call
  end
end

class FilmRecipesScrapJob
  def perform
    Scrappers::FilmRecipesScrapper.new(username: ENV.fetch('FILM_RECIPES_SCRAPPER_USERNAME'), logger: Crono.logger).call
  end
end

class FujiWeeklyScrapJob
  def perform
    data = {
      'xtrans5' => 'fujifilm-x-trans-v-recipes',
      'xtrans4' => 'fujifilm-x-trans-iv-recipes',
      'xtrans3' => 'fujifilm-x-trans-iii-recipes',
      'xtrans2' => 'fujifilm-x-trans-ii-recipes',
      'xtrans1' => 'fujifilm-x-trans-i-recipes',
      'bayer' => 'fujifilm-bayer-recipes',
      'gfx' => 'fujifilm-gfx-recipes',
    }

    data.each do |sensor, slug|
      Scrappers::FujiWeeklyScrapper.new(
        slug: slug,
        sensor: sensor,
        username: ENV.fetch('FUJI_WEEKLY_SCRAPPER_USERNAME'),
        logger: Crono.logger
      ).call
    end
  end
end

Crono.perform(CleanupOldCronoJobsJob).every 1.day
Crono.perform(CalculateRecipesCountForCamerasJob).every 10.minutes
Crono.perform(IvanYoloScrapJob).every 6.hours
Crono.perform(FilmRecipesScrapJob).every 6.hours
Crono.perform(FujiWeeklyScrapJob).every 6.hours
