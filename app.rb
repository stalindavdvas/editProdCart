# app.rb
require "sinatra"
require "json"
require_relative "config/redis"

# Middleware para CORS
before do
  content_type :json
  headers "Access-Control-Allow-Origin" => "*", 
          "Access-Control-Allow-Methods" => ["PUT", "OPTIONS"],
          "Access-Control-Allow-Headers" => ["Content-Type", "Authorization"]
end

options "*" do
  response.headers["Allow"] = "PUT, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
  200
end

# Update
put "/api/cart/:id" do
  user_id = "user:1" # User Key
  product_id = params[:id]

  begin
    payload = JSON.parse(request.body.read)
    new_quantity = payload["quantity"]

    if new_quantity.nil? || new_quantity <= 0
      status 400
      return { error: "Should a postive number" }.to_json
    end

    # Get actual stock
    product_json = $redis.hget(user_id, product_id)
    if product_json.nil?
      status 404
      return { error: "Product not found" }.to_json
    end

    # Update cant
    product_data = JSON.parse(product_json)
    product_data["quantity"] = new_quantity

    # Save product
    $redis.hset(user_id, product_id, product_data.to_json)

    status 200
    { message: "Cant update sucessfull" }.to_json
  rescue StandardError => e
    status 500
    { error: "Internal Server Error", message: e.message }.to_json
  end
end