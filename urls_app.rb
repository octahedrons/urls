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

- unless @url.empty?
  %h2 URLs
  %p
    %a{ href: "/json?url=#{@url}" } JSON
    %a{ href: "/txt?url=#{@url}" } Plain text

  %ul
    - @urls.each do |url|
      %li
        %a{ href: url }= url

  - if @urls.empty?
    %p No URLs found.
