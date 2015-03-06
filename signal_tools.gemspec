Gem::Specification.new do |gem|
  gem.name    = 'signal_tools'
  gem.version = '0.3.0'
  gem.date    = Date.today.to_s

  gem.summary = "Create technical analysis data for a given stock."
  gem.description = "Gem to create technical analysis data for a given stock (like MACD, stochastic, and exponential moving averages)."

  gem.authors  = ['Matt White']
  gem.email    = 'mattw922@gmail.com'
  gem.homepage = 'http://github.com/whitethunder/signal_tools'
  gem.files    = Dir['Rakefile', '{lib,test}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  gem.license  = 'MIT'

  gem.add_dependency('yahoofinance', '~> 1.2.0', '>= 1.2.0')

  gem.add_development_dependency('minitest', '~> 5.5.0', '>= 5.5.0')
end
