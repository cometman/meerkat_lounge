# Schedule for the jobs to run in minutes
# Setup Redis Server
redis_endpoint = nil
if Rails.env.production?
	redis_endpoint = "meerkat-lounge-001.nzhcsh.0001.use1.cache.amazonaws.com"
elsif Rails.env.integration? && ENV['EB_CONFIG_APP_CURRENT'].present?
	redis_endpoint = "meerkat-lounge-001.nzhcsh.0001.use1.cache.amazonaws.com"
else
	redis_endpoint = "127.0.0.1"
end

$redis = Redis.new(:host => "#{redis_endpoint}")

Sidekiq.configure_server do |config| 
  config.redis = { :url => "redis://#{redis_endpoint}:6379"}
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{redis_endpoint}:6379"}
end

