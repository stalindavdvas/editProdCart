# config/redis.rb
require "redis"

# Configuración de Redis
REDIS_HOST = ENV["REDIS_HOST"] || "52.5.28.74"
REDIS_PORT = ENV["REDIS_PORT"] || 6379

$redis = Redis.new(host: REDIS_HOST, port: REDIS_PORT)

begin
  $redis.ping
  puts "Conexión exitosa a Redis"
rescue StandardError => e
  puts "Error al conectar a Redis: #{e.message}"
end