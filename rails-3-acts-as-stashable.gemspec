# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{rails-3-acts-as-stashable}
  s.version = '0.1.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ["Steven Anderson"]
  s.email = %q{steve@whilefalse.net}
  s.homepage = %q{http://github.com/whilefalse/rails-3-acts-as-stashable}
  s.summary = %q{Allow stashing active record objects in the session in Rails 3.}
  s.description = %q{Allow stashing active record objects in the session in Rails 3.}

  s.add_dependency('rails', '~>3.0.0')

  s.add_development_dependency('sqlite3-ruby')
  s.add_development_dependency('rspec-rails')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

