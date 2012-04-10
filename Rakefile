require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"



task :default => :package do
  puts "Don't forget to write some tests!"
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "panelbeater"
  s.version           = "0.1.6"
  s.summary           = "A gem for communicating with the cPanel and WHM API's"
  s.author            = "Jamie Dyer"
  s.email             = "jamie@kernowsoul.com"
  s.homepage          = "http://kernowsoul.com"

  s.has_rdoc          = false
  # You should probably have a README of some kind. Change the filename
  # as appropriate
  # s.extra_rdoc_files  = %w(README)
  # s.rdoc_options      = %w(--main README)

  # Add any extra files to include in the gem (like your README)
  s.files             = %w() + Dir.glob("{**/*}")
  s.test_files = Dir.glob('test/fixtures/*') + Dir.glob('test/*.rb') + Dir.glob('test/*.example')
  
  s.require_paths = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency("json")

  # If your tests use any gems, include them here
  s.add_development_dependency("shoulda")
  s.add_development_dependency("webmock")

  # If you want to publish automatically to rubyforge, you'll may need
  # to tweak this, and the publishing task below too.
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
