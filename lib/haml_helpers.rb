require "sinatra/base"
require "sinatra/capture"

module Sinatra
  module HamlHelpers
    include Sinatra::Capture

    def surround(front, back = front, &block)
      "#{front}#{capture_haml(&block).chomp}#{back}\n"
    end

    def precede(str, &block)
      "#{str}#{capture_haml(&block).chomp}\n"
    end

    def succeed(str, &block)
      "#{capture_haml(&block).chomp}#{str}\n"
    end

    def capture_haml(*args, &block)
      capture(*args, &block)
    end
  end

  helpers HamlHelpers
end
