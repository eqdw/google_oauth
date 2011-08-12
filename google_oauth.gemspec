# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'google_oauth/version'

Gem::Specification.new do |s|
   s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.name = "google_oauth"
  s.version = GoogleOAuth::VERSION

  s.authors = ["Richard Taylor", "Tim Herd"]
  s.date = "2011/08/12"

  s.description = %q{google_oauth is a OAuth2 Ruby client library for the Google Data APIs}
  s.summary     = %q{google_oauth is a OAuth2 Ruby client library for the Google Data APIs}

  s.email = %q{moomerman@gmail.com timherd@eqdw.net}
  s.files = `git ls-files`.split("\n")
  s.homepage = %q{http://github.com/erauqssidlroweht/google_oauth}
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth2>, [">= 0.0.8"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.9"])
      %w(shoulda mocha).each do |dep|
        s.add_development_dependency dep
      end
    else
      s.add_dependency(%q<oauth2>, [">= 0.0.8"])
      s.add_dependency(%q<json>, [">= 1.1.9", "<= 1.2.4"])
    end
  else
    s.add_dependency(%q<oauth2>, [">= 0.0.8"])
    s.add_dependency(%q<json>, [">= 1.1.9"])
  end
end
