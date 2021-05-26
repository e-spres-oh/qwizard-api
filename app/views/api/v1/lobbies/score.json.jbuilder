json.array! @results do |result|
  json.extract! result, :name, :hat, :points
end
