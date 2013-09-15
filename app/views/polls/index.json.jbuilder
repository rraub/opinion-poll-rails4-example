json.array!(@polls) do |poll|
  json.extract! poll, 
  json.url poll_url(poll, format: :json)
end
