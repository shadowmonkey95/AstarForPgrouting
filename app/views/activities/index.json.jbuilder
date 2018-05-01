json.array! @activities do |activity|
  json.id activity.id
  json.recipient_id activity.recipient_id
  json.url invoice_path(activity.trackable_id)
end