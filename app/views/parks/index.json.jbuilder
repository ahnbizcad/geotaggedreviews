json.array!(@parks) do |park|
  json.extract! park, :id
  json.url park_url(park, format: :json)
end
