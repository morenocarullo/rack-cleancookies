# Rack middleware that drops non properly encoded cookies that would hurt the ActionDispatch::Cookies middleware.
#
# This is actually a hotfix for issues
# * https://github.com/rack/rack/issues/225
# * https://github.com/rails/rails/issues/2622
module Rack
  module CleanCookies
    # Tests whether a string may be decoded as a form component
    def decodable?(string)
      URI.decode_www_form_component(string)
      true
    rescue ArgumentError => e
      /^invalid %-encoding \(.*\)$/.match(e.message) ? false : raise
    end

    module_function :decodable?

    # Tests whether a cookie is clean, that is its key and value may be decoded as a form components
    def clean?(cookie)
      key, value = cookie.split('=', 2)
      decodable?(key) && decodable?(value)
    end

    module_function :clean?

    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['HTTP_COOKIE']
          clean_cookies, dirty_cookies = [], []

          # Split cookies into clean and dirty
          env['HTTP_COOKIE'].split(/[;,] */n).each do |cookie|
            if CleanCookies::clean?(cookie)
              clean_cookies << cookie
            else
              dirty_cookies << cookie
            end
          end

          # Keep only clean cookies
          env['HTTP_COOKIE'] = clean_cookies.join('; ')

          # Inform about dropped dirty cookies
          unless dirty_cookies.empty?
            env['rack.errors'].puts "Ignoring dirty cookies: #{dirty_cookies.inspect}"
          end
        end

        # Carry on
        @app.call(env)
      end
    end
  end
end