require 'bundler/gem_tasks'

namespace :spec do
  namespace :integrations do
    desc 'Test rails 4.2'
    task :rails_4_2 do
      exec "export && #{__dir__}/spec/integrations/rails_4_2/test.sh"
    end
  end
end

task default: %w[spec:integrations:rails_4_2 build]
