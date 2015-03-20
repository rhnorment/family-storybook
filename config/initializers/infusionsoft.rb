Infusionsoft.configure do |config|
  config.api_url = 'bq234.infusionsoft.com'
  config.api_key = '696280ecdd8dd6061b100d12e3760834'
  config.api_logger = Logger.new("#{Rails.root}/log/infusionsoft_api.log")
end