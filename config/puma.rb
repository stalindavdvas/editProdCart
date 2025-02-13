# config/puma.rb
workers 2
threads_count = 5
threads threads_count, threads_count

port        ENV.fetch("PORT") { 4567 }
environment ENV.fetch("RACK_ENV") { "development" }

preload_app!

on_worker_boot do
  # Reconnect to Redis if needed
end