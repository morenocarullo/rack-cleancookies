Gem::Specification.new do |s|
  s.name        = "rack-cleancookies"
  s.version     = '0.1.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Moreno Carullo"]
  s.summary     = 'Clean dirty cookies from Rack environment'
  s.homepage    = 'https://github.com/morenocarullo/rack-cleancookies'

  s.add_runtime_dependency('rake')
  s.add_runtime_dependency('rack')

  s.add_development_dependency('test-unit')

  s.files        = Dir.glob("{lib}/**/*.rb")
  s.require_paths = ['lib']
end