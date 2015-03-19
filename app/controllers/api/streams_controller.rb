class Api::StreamsController < ApplicationController
  # before_filter :set_xhr
  # before_filter :authenticate_user!, :except => [:create]
  layout nil
  include ActionController::Live

  # Retrieve all users for the authenticating account
  #
  # @return [Users] All users for the account
  def index
    # byebug
    page = params[:page] || 0
    number_of_streams = 10
    order_by = "created_at"
    direction = "DESC"
    streams = Stream.all#where(status: "live")
    search = params[:q]
    if search.present? && search != ""
      streams = streams.any_of({"broadcaster.name" => /#{search}/i}, {"caption" => /#{search}/i}, {"influencers" => /#{search}/i}, {"location" => /#{search}/i}).page(page).per(number_of_streams).order_by(order_by + ' ' + direction)
    else
      streams = streams.page(page).per(number_of_streams).order_by(order_by + ' ' + direction)
    end

    render :json => streams.map(&:as_document)
  end

  # # Streaming API to retrieve users in a stream
  # def stream
  #   response.headers['Content-Type'] = 'text/event-stream'
  #   tags = nil
  #   all_users = Appconsumer.any_in(:app_id => my_app_ids)
  #   # If tags were passed in search for users that had this tag
  #   if params[:tags].present?
  #     tags = params[:tags]
  #     # Find all tags for the users, and then select on the ID's that have a tag
  #     tagged_users = UserTag.any_in(name: tags).any_in(:appconsumer_id => all_users.map(&:id)).only(:appconsumer_id).map(&:appconsumer_id)
  #     # From our users, only keep users who have the given tag (tagged_users) 
  #     all_users = all_users.any_in(:id => tagged_users)
  #   end
  #   users = all_users

  #   users.each do |u|
  #     u["total_size"] = all_users.count
  #     u["picture"] = Appconsumer.find(u["_id"]).get_picture
  #     u["posts"] = Impression.any_in(:app_id => my_app_ids).where(appconsumer_id: u["_id"]).count
  #     # u["tags"] = UserTag.where(appconsumer_id: u["_id"])
  #     data = Hash.new
  #     data["data"] = u
  #     response.stream.write data.to_json
  #     response.stream.write "\n\n"
  #   end
  # ensure
  #   response.stream.close
  # end
end
