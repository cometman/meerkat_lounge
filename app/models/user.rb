class User
  include Mongoid::Document
  field :name, type: String
  field :id_str, type: String
  field :screen_name, type: String
  field :profile_image_url, type: String
  field :followers_count, type: Integer
  field :location, type: String

  
  embedded_in :twitter
end
