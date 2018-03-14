Gem::Specification.new do |s|
  s.name        = 'kibutsu'
  s.version     = '1.0.5'
  s.date        = '2017-11-10'
  s.summary     = 'A fixture library for sequel'
  s.description = "Kibutsu is an easy-to-use database fixture library.

The only dependency kibutsu has is the sequel gem. Thus, you may use it \
with any project that uses sequel, e.g. with a hanami app!"
  s.authors     = ['Ferdinand Niedermann']
  s.email       = 'ferdinand.niedermann@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/nerdinand/kibutsu'
  s.license     = 'MIT'

  s.add_runtime_dependency 'sequel', ['~> 4.49.0']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop'
end
