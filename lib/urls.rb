require "open-uri"
require "twingly/url"

module Urls
  module_function

  def by_url(url)
    uri = Twingly::URL.parse(url).url.to_s

    return [] if uri.empty?

    doc = open(uri)

    by_text(doc.read)
  end

  def by_text(text)
    urls_and_crap = URI.extract(text)
    urls_and_crap.
      select { |url| Twingly::URL.validate(url) }.
      uniq
  end
end
