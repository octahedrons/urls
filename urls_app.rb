require "sinatra"
require "sinatra/json"
require "sinatra/reloader" if development?
require "haml"

require_relative "lib/urls"

configure do
  enable :inline_templates
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

post "/" do
  @text = params[:text]
  @urls = Urls.by_text(@text)

  case params[:submit]
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
    %title URI Extract
  %body
    = yield

@@ index

- port = [80, 443].include?(request.port) ? "" : ":#{request.port}"
- example_url = "#{request.scheme}://#{request.host}#{port}/?url=blog.trello.com"
%p
  Returns a list of URLs using Ruby and
  = succeed "." do
    %a{ href: "https://github.com/twingly/twingly-url" } twingly-url

%p
  Example:
  %a{ href: example_url }= example_url

- unless @urls.empty?
  %h2 URLs
  - unless request.request_method == "POST"
    %p
      %a{ href: "/json?url=#{@url}" } JSON
      %a{ href: "/txt?url=#{@url}" } Plain text

  %ul
    - @urls.each do |url|
      %li
        %a{ href: url }= url

  - if @urls.empty?
    %p No URLs found.

%p Or paste text with URLs

%form{ method: :post }
  %p
    %input{ type: :submit, name: :submit, value: :html }
    %input{ type: :submit, name: :submit, value: :json }
    %input{ type: :submit, name: :submit, value: :txt }
  %textarea{ name: :text, cols: 150, rows: 25 }= @text
