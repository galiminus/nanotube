module ApplicationHelper
  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= t(:"errors.template.header", model: t(:"activerecord.models.#{objects.compact.first.class.name.downcase}"), count: objects.compact.first.errors.messages.size)
    options[:message] ||= t(:"errors.template.body")
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, id: "error_explanation", class: "notification is-danger is-radiusless") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  def video_path(post)
    ENV["PUBLIC_VIDEOS_PATH"] + "/" + post.name
  end

  def thumbnail_path(post)
    ENV["PUBLIC_VIDEOS_PATH"] + "/" + post.thumbnail
  end
end
