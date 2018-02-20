require "metainspector"
require "twingly/url"

module Urls
  module_function

  def by_url(url)
    uri = Twingly::URL.parse(url).to_s

    return [] if uri.empty?

    options = {
      warn_level: :store,
      download_images: false,
      html_content_only: true,
    }

    page = MetaInspector.new(uri, options)
    page.links.external
  end

  def by_text(text)
    urls_and_crap = URI.extract(text)
    urls_and_crap
      .map { |url| Twingly::URL.parse(url) }
      .select { |url| url.valid? }
      .map(&:to_s)
      .uniq
  end
end
