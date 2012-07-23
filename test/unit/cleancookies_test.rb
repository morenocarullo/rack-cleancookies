require File.dirname(__FILE__) + '/../test_case'

module Rack
  module CleanCookies
    class RackTest < Test::Unit::TestCase
      COOKIE_OK = 'okcookie=okvalue'
      BAD_COOKIE = 'badcookie=1%G15%G%G1335185427000%G%G%G%G%G'

      def setup
        @errors = StringIO.new
        @rack = CleanCookies::Middleware.new(lambda { |env| [200, {}, 'hello'] })
      end

      def test_keeps_clean_cookie
        env = env_with_cookies(COOKIE_OK + "; " + BAD_COOKIE)
        @rack.call(env)

        assert_equal COOKIE_OK, env['HTTP_COOKIE']
      end

      def test_removes_dirty_cookie
        env = env_with_cookies(BAD_COOKIE)
        @rack.call(env)

        assert_empty env['HTTP_COOKIE']
      end

      def env_with_cookies(cookies)
        { 'HTTP_COOKIE' => cookies, 'rack.errors' => @errors }
      end
    end
  end
end