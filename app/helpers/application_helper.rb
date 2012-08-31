module ApplicationHelper

  def markdown(text)
    Redcarpet::Markdown.render(text).try(:html_safe)
  end

  def md2plain(text)
    doc = Nokogiri::HTML(markdown(text))
    doc.xpath("//text()").to_s
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
    Preference.html.title
  end

  def html_keywords
    Preference.html.keywords
  end

  def html_description
    Preference.html.description
  end

end
