require 'bundler/gem_helper'

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

namespace :gem do
  Bundler::GemHelper.install_tasks
end

task :test do
  sh 'test/test.sh'
  sh 'test/test_plugin_does_not_break_vagrant.sh'
end
