module ApplicationHelper

  def markdown(text)
    Redcarpet::Markdown.render(text).try(:html_safe)
  end

  def plain(text)
    doc = Nokogiri::HTML(markdown(text))
    doc.xpath("//text()").to_s
  end

  def diff(o, m)
    Diffy::Diff.new(o, m, diff: '-u', include_diff_info: true, include_plus_and_minus_in_html: false, allow_empty_diff: true).to_s(:html).html_safe
  end

  def timeago(time, options = {})
    timeago_tag(time.utc, options.reverse_merge(:limit => 7.days.ago))
  end

  def render_html_head
    %{<title>#{html_title}</title>
    <meta name="keywords" content="#{html_keywords}" />
    <meta name="description" content="#{html_description}" />}.html_safe
  end

  def html_title
    title = @post && @post.title || @tag && @tag.title
    title.blank? ? Preference.html.title : title + ' | ' + Preference.html.title
  end

  def html_keywords
    tags = @post && @post.tags.map(&:title).join(',')
    tags.blank? ? Preference.html.keywords : tags
  end

  def html_description
    desc = @post && @post.content
    desc.blank? ? Preference.html.description : plain(desc)[0..160]
  end

end
