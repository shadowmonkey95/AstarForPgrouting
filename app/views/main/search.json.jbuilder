json.shops do
  json.array!(@shops) do |shop|
    json.name shop.name
    json.url user_shop_path(shop.user_id, shop)
  end
end

json.requests do
  json.array!(@requests) do |request|
    json.name request.destination_address
    json.url user_shop_request_path(current_user.id, request.shop_id, request)
  end
end