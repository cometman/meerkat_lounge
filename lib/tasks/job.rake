ENV["RAILS_ENV"] ||= "test"
namespace :job do
  desc "Attach new feeds to stream task every 30 seconds"
  task :attach_streams => :environment do
    puts "Beginning attaching feeds"
    Feed.any_of({stream_id: nil},{update_status: {"$exists" => false}}, {update_status: true}).each do |feed|
      feed.attach_to_stream
    end
  end

  desc "Update all feeds every 30 seconds"
  task :update_streams => :environment do
    puts "Attach new feeds to streams"
    Stream.where(status: "live").each do |stream|
      stream.update_stream
    end
  end
end
