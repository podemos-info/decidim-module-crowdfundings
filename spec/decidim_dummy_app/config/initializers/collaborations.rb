Decidim::Collaborations.configure do |config|
  config.maximum_annual_collaboration = 1_000_000
  config.census_api_proxy_address = '127.0.0.1'
  config.census_api_proxy_port = 8118
  config.census_api_debug = true
  config.census_api_base_uri = 'https://census-api.unpais.es'
end