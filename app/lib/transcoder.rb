class Transcoder
  def self.transcode(path, destination)
    system("ffmpeg -y -i '#{path}' -r 25 -c:v libx264 -strict -2 -movflags faststart  -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -preset ultrafast -crf 22 '#{destination}'", out: File::NULL)
    raise if $?.to_i != 0 || File.size?(destination) == 0

    destination
  end

  def self.create_thumbnail(path, destination)
    system("ffmpeg -i #{path} -ss 00:00:10 -vframes 1 #{destination}")
  end
end
