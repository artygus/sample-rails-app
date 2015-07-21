json.array!(@trips) do |trip|
  json.extract! trip, :id, :destination, :start_date, :end_date, :comment, :user_id
  json.url trip_url(trip, format: :json)
end
