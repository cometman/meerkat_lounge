json.array!(@feeds) do |feed|
  json.extract! feed, :id, :author, :thumbnail, :stream_link
  json.url feed_url(feed, format: :json)
end
