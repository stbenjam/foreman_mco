$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreman-mco/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreman-mco"
  s.version     = ForemanMco::VERSION
  s.authors     = ["Dmitri Dolguikh", "Sam Kottler"]
  s.email       = ["dmitri@appliedlogic.ca", "skottler@redhat.com"]
  s.homepage    = "https://github.com/witlessbird/foreman_mco"
  s.summary     = "Manage remote execution using Foreman + MCollective"
  s.description = "Manage remote execution using Foreman + MCollective"
  s.licenses = ["GPL-3"]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "deface"
  s.add_development_dependency "sqlite3"
end
