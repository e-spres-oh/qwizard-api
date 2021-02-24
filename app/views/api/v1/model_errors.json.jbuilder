json.errors do
  json.array! errors.errors do |error|
    json.attribute error.attribute
    json.error error.type
    json.message error.message
  end
end