require "cgi"
require "dyno_metadata"
require "haml"
require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "lib/urls"

configure do
  enable :inline_templates
end

before do
  @text = nil
end

get "/" do
  @url = params[:url].to_s
  @urls = Urls.by_url(@url)

  haml :index
end

get "/json" do
  @url = params[:url].to_s
  @urls = Urls.by_url(@url)

  json @urls
end

get "/txt" do
  @url = params[:url].to_s
  @urls = Urls.by_url(@url)

  content_type "text/plain"
  body @urls.join("\n")
end

get "/text" do
  redirect(url("/"))
end

post "/text" do
  @url  = false
  @text = params[:text]
  ext, normalize = params[:submit]&.split(" ")
  @urls = Urls.by_text(@text, normalize: !!normalize)

  if params[:remove_scheme]
    @urls.map! { |url| Urls.remove_scheme(url) }
  end

  if params[:sort]
    @urls.sort!
  end

  case ext
  when "json"
    json @urls
  when "txt"
    content_type "text/plain"
    body @urls.join("\n")
  else
    haml :index
  end
end

__END__

@@ layout
%html
  %head
    %title urls
  %body
    = yield

@@ index

- port = [80, 443].include?(request.port) ? "" : ":#{request.port}"
- example_url = "#{request.scheme}://#{request.host}#{port}/?url=blog.trello.com"
%p
  %a{ href: "/" } urls
  returns a list of URLs using
  %a{ href: "https://github.com/dentarg/urls" } Ruby
  and
  = succeed "." do
    %a{ href: "https://github.com/twingly/twingly-url" } twingly-url
  Example:
  %a{ href: example_url }= example_url

%p
  %form
    %input{ type: :text, name: :url, value: @url, placeholder: :URL, size: 50 }
    %input{ type: :submit }

- if @urls.empty?
  %p
    No URLs found!
- else
  - if @url
    %h2
      = "#{@urls.count} URLs for"
      %code= @url
    %p
      %a{ href: "/json?url=#{@url}" } JSON
      %a{ href: "/txt?url=#{@url}" } Plain text
  - else
    %h2= "#{@urls.count} URLs"
  %ul
    - @urls.each do |url|
      %li
        %a{ href: url }= url

%p Or paste text with URLs

%form{ method: :post, action: "/text" }
  %textarea{ name: :text, cols: 150, rows: 25 }= CGI.escape_element(@text.to_s, "textarea")
  %p
    %label{ for: :remove_scheme } Remove scheme?
    %input{ type: :checkbox, name: :remove_scheme, id: :remove_scheme, checked: true }

    %label{ for: :sort } Sort?
    %input{ type: :checkbox, name: :sort, id: :sort, checked: true }
  %p
    %input{ type: :submit, name: :submit, value: "html normalized" }
    %input{ type: :submit, name: :submit, value: "json normalized" }
    %input{ type: :submit, name: :submit, value: "txt normalized" }
  %p
    %input{ type: :submit, name: :submit, value: :html }
    %input{ type: :submit, name: :submit, value: :json }
    %input{ type: :submit, name: :submit, value: :txt }

%p
  %code
    Running urls
    %a{ href: "https://github.com/dentarg/urls/commit/#{DynoMetadata.commit}" }= DynoMetadata.release_version
    = " (#{DynoMetadata.release_created_at})"
