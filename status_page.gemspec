
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "status_page/version"

Gem::Specification.new do |spec|
  spec.name          = "status_page"
  spec.version       = StatusPage::VERSION
  spec.authors       = ["ali.krgn"]
  spec.email         = ["ali.sancopanco@gmail.com"]

  spec.summary       = %q{ Think of the tool as a CLI version of sites like https://statuspages.me/. }
  spec.homepage      = "https://github.com/sancopanco/status-page"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"
  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
