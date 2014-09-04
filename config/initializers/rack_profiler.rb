#if Rails.env == 'development'
#  require 'rack-mini-profiler'
#
#  # initialization is skipped so trigger it
#  Rack::MiniProfilerRails.initialize!(Rails.application)
#end
#
## Do not let rack-mini-profiler disable caching
#Rack::MiniProfiler.config.disable_caching = false # defaults to true 