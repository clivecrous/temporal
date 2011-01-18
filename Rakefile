require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

desc "unit tests"
task :test do
  exec 'cd lib && bundle exec rspec ../test/*'
end
