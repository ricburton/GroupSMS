# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mediaburst"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Hall"]
  s.date = "2011-08-10"
  s.description = "Wrapper for the Mediaburst SMS sending API"
  s.email = ["matt@codebeef.com"]
  s.homepage = "http://www.mediaburst.co.uk/api"
  s.licenses = ["ISC"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby wrapper for the Mediaburst SMS API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
