require_relative '../../lib/cypress/middleware'

RSpec.describe Cypress::Middleware do
  let(:app) { ->(env) { [200, {}, ["app did #{env['PATH_INFO']}"]] } }
  let(:kernel) { class_double(Kernel) }
  let(:file) { class_double(File) }
  subject { described_class.new(app, kernel, file) }

  let(:env) { {} }

  def rack_input(json_value)
    StringIO.new(JSON.generate(json_value))
  end

  context '/__cypress__/command' do
    before do
      allow(kernel).to receive(:load)
      allow(file).to receive(:exists?)
      env['PATH_INFO'] = '/__cypress__/command'
    end

    it 'command file exists' do
      env['rack.input'] = rack_input(name: 'seed')
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/seed.rb').and_return(true)

      response = subject.call(env)

      expect(response).to eq([201, {}, ['success']])
      expect(kernel).to have_received(:load).with('spec/cypress/app_commands/seed.rb')
    end

    it 'command file does not exists' do
      env['rack.input'] = rack_input(name: 'seed')
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/seed.rb').and_return(false)

      response = subject.call(env)

      expect(response).to eq([404, {}, ['could not find command file: spec/cypress/app_commands/seed.rb']])
      expect(kernel).to_not have_received(:load)
    end
  end

  context '/__cypress__/eval' do
    before do
      allow(kernel).to receive(:eval) { 'eval_result'}
      env['PATH_INFO'] = '/__cypress__/eval'
    end

    it 'runs the code' do
      env['rack.input'] = rack_input(code: 'Run.me.please')

      response = subject.call(env)

      expect(response).to eq([201, {}, ['eval_result']])
      expect(kernel).to have_received(:eval).with('Run.me.please')
    end
  end

  context '"Other paths"' do
    it 'runs app' do
      aggregate_failures do
        %w(/ /__cypress__/login command /cypress_command /).each do |path|
          env['PATH_INFO'] = path

          response = subject.call(env)

          expect(response).to eq([200, {}, ["app did #{path}"]])
        end
      end
    end
  end
end
