Gem::Specification.new do |s|
  s.name        = 'kibutsu'
  s.version     = '0.0.0'
  s.date        = '2017-11-10'
  s.summary     = 'Fixtures for hanami'
  s.description = "A poor man's fixture library for hanami"
  s.authors     = ['Ferdinand Niedermann']
  s.email       = 'ferdinand.niedermann@gmail.com'
  s.files       = ['lib/kibutsu.rb']
  s.homepage    =
    'http://rubygems.org/gems/kibutsu'
  s.license       = 'MIT'
  s.add_runtime_dependency 'sequel', ['~> 4.49.0']
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'sqlite3'
end
