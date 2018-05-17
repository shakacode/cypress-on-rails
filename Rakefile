require 'bundler/gem_tasks'


require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/cypress/*_spec.rb'
end

task default: %w[spec build]
