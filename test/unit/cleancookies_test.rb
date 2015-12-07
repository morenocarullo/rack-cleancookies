require File.dirname(__FILE__) + '/../test_case'

module Rack
  module CleanCookies
    class RackTest < Test::Unit::TestCase
      COOKIE_OK = 'okcookie=okvalue'
      BAD_COOKIE = 'badcookie=1%G15%G%G1335185427000%G%G%G%G%G'
      BAD_EMPTY_COOKIE = 'badcookie_empty'

      def setup
        @errors = StringIO.new
        @rack = CleanCookies::Middleware.new(lambda { |env| [200, {}, 'hello'] })
      end

      def test_keeps_clean_cookie
        process COOKIE_OK + '; ' + BAD_COOKIE

        assert_equal COOKIE_OK, @env['HTTP_COOKIE']
        assert_empty @errors.string
      end

      def test_removes_dirty_cookie
        process BAD_COOKIE

        assert_empty @env['HTTP_COOKIE']
        assert_empty @errors.string
      end

      def test_empty_cookie_doesnt_raise
        assert_nothing_raised { process BAD_EMPTY_COOKIE }
      end

      def test_rack_errors_if_verbose
        @rack = CleanCookies::Middleware.new(lambda { |env| [200, {}, 'hello'] }, verbose: false)

        process BAD_COOKIE

        assert_equal '', @errors.string
      end

      def process(cookies)
        @env = env_with_cookies(cookies)
        @rack.call(@env)
      end

      def env_with_cookies(cookies)
        {'HTTP_COOKIE' => cookies, 'rack.errors' => @errors}
      end
    end
  end
end