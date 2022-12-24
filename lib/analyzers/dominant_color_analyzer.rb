class Analyzers::DominantColorAnalyzer < ActiveStorage::Analyzer::ImageAnalyzer
  def self.accept?(blob)
    blob.image?
  end

  def metadata
    download_blob_to_tempfile do |file|
      colors = RailsDominantColors::Path.new(file.path, 1)

      {
        dominant_color: colors.to_hex.first
      }
    end
  end
end
