# frozen_string_literal: true

$stdout.sync = true
$stderr.sync = true

require_relative "urls_app"

run Sinatra::Application
