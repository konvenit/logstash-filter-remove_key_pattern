Gem::Specification.new do |s|
  s.name          = 'logstash-filter-remove_key_pattern'
  s.version       = '0.1.3'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Remove all keys that match pattern'
  s.authors       = ['Arthur Alfredo']
  s.email         = 'a.alfredo@miceportal.com'
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/konvenit/logstash-filter-remove_key_pattern'

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','Gemfile','LICENSE']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_development_dependency 'logstash-devutils', "~> 1.3", ">= 1.3.0"
end
