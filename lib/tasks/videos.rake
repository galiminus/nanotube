namespace :videos do
  task :transcode => :environment do
    file_path = Rails.root.join("public").join("videos")

    Post.where(state: "enqueued").order(created_at: :asc).each do |post|
      begin
        post.start_building!
        
        name = "#{post.name.gsub(/\.[^\.]+$/, '').parameterize.underscore}-#{SecureRandom.uuid}.mp4"
      
        Transcoder.transcode(post.path, "#{file_path}/#{name}")

        thumbnail = name.gsub(/\.[^\.]+$/, '.jpg')
        Transcoder.create_thumbnail("#{file_path}/#{name}", "#{file_path}/#{thumbnail}")

        post.mark_as_built!
        post.update({
                      path: "#{file_path}/#{name}",
                      thumbnail: thumbnail,
                      name: name
                    })
      rescue => e
        puts e
        puts e.backtrace
        post.mark_as_build_failed!
      end
    end
  end
end
