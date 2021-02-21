json.array! @scores do |res|
  json.extract! res, :name, :hat, :points
end
