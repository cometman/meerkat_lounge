ENV["RAILS_ENV"] ||= "test"
namespace :job do
  desc "Attach new feeds to stream task every 30 seconds"
  task :attach_streams => :environment do
    puts "Beginning attaching feeds"
    Feed.any_of({processed: false},{processed: {"$exists" => false}}).each do |feed|
      feed.attach_to_stream
    end
  end

  desc "Update all feeds [2] minutes"
  task :update_streams => :environment do
    puts "Attach new feeds to streams"
    Stream.where(status: "live").each do |stream|
      stream.update_stream
    end
  end
end
