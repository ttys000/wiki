module WikiLinkHelper
  def render_wiki_body(body)
    return "".html_safe if body.blank?

    # Collect all referenced slugs to batch-check existence
    slugs = body.scan(/\[\[(.+?)\]\]/).flatten.map { |t| t.parameterize.presence || t.strip }
    existing = Page.where(slug: slugs).pluck(:slug).to_set

    # HTML-escape the body, then replace [[links]]
    html = ERB::Util.html_escape(body)
    html = html.gsub(/\[\[(.+?)\]\]/) do
      title = Regexp.last_match(1)
      slug = title.parameterize.presence || title.strip
      css = existing.include?(slug) ? "wiki-link" : "wiki-link new-page"
      %(<a href="#{page_path(slug)}" class="#{css}">#{ERB::Util.html_escape(title)}</a>)
    end

    simple_format(html, {}, sanitize: false)
  end
end
