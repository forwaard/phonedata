require_relative 'lib/phonedata/version'

Gem::Specification.new do |spec|
  spec.name          = "phonedata"
  spec.version       = Phonedata::VERSION
  spec.license       = "MIT"
  spec.authors       = ["Forwaard"]
  spec.email         = ["forwaard@163.com"]

  spec.summary       = "query the attribution of Chinese mobile phone numbers."
  spec.description   = "query the attribution of Chinese mobile phone numbers.中国手机号码归属地信息库、手机号归属地查询。"
  spec.homepage      = "https://github.com/FORWAARD/phonedata-ruby"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/FORWAARD/phonedata-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = ["ph2loc"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.2"
end
