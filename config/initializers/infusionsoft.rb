Infusionsoft.configure do |config|
  config.api_url = 'bq234.infusionsoft.com'
  config.api_key = 'y4sj2w6hh8tub34b2ukax7an'
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log")
end