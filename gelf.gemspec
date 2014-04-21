# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gelf"
  s.version = "1.4.0.beta2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexey Palazhchenko", "Lennart Koopmann"]
  s.date = "2014-04-21"
  s.description = "Library to send GELF messages to Graylog2 logging server. Supports plain-text, GELF messages and exceptions."
  s.email = "alexey.palazhchenko@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".gemtest",
    ".travis.yml",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "benchmarks/incremental.rb",
    "benchmarks/notifier.rb",
    "gelf.gemspec",
    "lib/gelf.rb",
    "lib/gelf/logger.rb",
    "lib/gelf/notifier.rb",
    "lib/gelf/ruby_sender.rb",
    "lib/gelf/severity.rb",
    "test/helper.rb",
    "test/test_logger.rb",
    "test/test_notifier.rb",
    "test/test_ruby_sender.rb",
    "test/test_severity.rb"
  ]
  s.homepage = "http://github.com/Graylog2/gelf-rb"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Library to send GELF messages to Graylog2 logging server."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
  end
end

