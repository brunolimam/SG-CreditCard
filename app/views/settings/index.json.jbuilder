json.array!(@settings) do |setting|
  json.extract! setting, :id, :parameter, :description, :value
  json.url setting_url(setting, format: :json)
end
