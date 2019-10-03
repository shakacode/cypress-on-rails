require 'cypress_on_rails/middleware'

RSpec.describe CypressOnRails::Middleware do
  class DummyResult
    def as_json(_)
      { id: 1, title: 'some result' }
    end

    def to_json(_)
      as_json(_).to_json
    end
  end

  let(:app) { ->(env) { [200, {}, ["app did #{env['PATH_INFO']}"]] } }
  let(:command_executor) { class_double(CypressOnRails::CommandExecutor) }
  let(:file) { class_double(File) }
  subject { described_class.new(app, command_executor, file) }

  let(:env) { {} }

  let(:response) { subject.call(env) }

  let(:results) { [DummyResult.new]}

  def rack_input(json_value)
    StringIO.new(JSON.generate(json_value))
  end

  context '/__cypress__/command' do
    before do
      allow(command_executor).to receive(:load).and_return(results)
      allow(file).to receive(:exists?)
      env['PATH_INFO'] = '/__cypress__/command'
    end

    it 'command file exists' do
      env['rack.input'] = rack_input(name: 'seed')
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/seed.rb').and_return(true)

      aggregate_failures do
        expect(response).to eq([201, {}, ["[{\"id\":1,\"title\":\"some result\"}]"]])
        expect(command_executor).to have_received(:load).with('spec/cypress/app_commands/seed.rb', nil)
      end
    end

    it 'command file exists with options' do
      env['rack.input'] = rack_input(name: 'seed', options: ['my_options'])
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/seed.rb').and_return(true)

      aggregate_failures do
        expect(response).to eq([201, {}, ["[{\"id\":1,\"title\":\"some result\"}]"]])
        expect(command_executor).to have_received(:load).with('spec/cypress/app_commands/seed.rb', ['my_options'])
      end
    end

    it 'command file does not exists' do
      env['rack.input'] = rack_input(name: 'seed')
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/seed.rb').and_return(false)

      aggregate_failures do
        expect(response).to eq([404, {}, ['could not find command file: spec/cypress/app_commands/seed.rb']])
        expect(command_executor).to_not have_received(:load)
      end
    end

    it 'running multiple commands' do
      env['rack.input'] = rack_input([{name: 'load_user'},
                                      {name: 'load_sample', options: {'all' => 'true'}}])
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/load_user.rb').and_return(true)
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/load_sample.rb').and_return(true)

      aggregate_failures do
        expect(response).to eq([201, {}, ["[{\"id\":1,\"title\":\"some result\"},{\"id\":1,\"title\":\"some result\"}]"]])
        expect(command_executor).to have_received(:load).with('spec/cypress/app_commands/load_user.rb', nil)
        expect(command_executor).to have_received(:load).with('spec/cypress/app_commands/load_sample.rb', {'all' => 'true'})
      end
    end

    it 'running multiple commands but one missing' do
      env['rack.input'] = rack_input([{name: 'load_user'}, {name: 'load_sample'}])
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/load_user.rb').and_return(true)
      allow(file).to receive(:exists?).with('spec/cypress/app_commands/load_sample.rb').and_return(false)

      aggregate_failures do
        expect(response).to eq([404, {}, ['could not find command file: spec/cypress/app_commands/load_sample.rb']])
        expect(command_executor).to_not have_received(:load)
      end
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

  context 'without stubs' do
    subject { described_class.new(app) }

    it 'runs' do
      env['PATH_INFO'] = '/test'

      response = subject.call(env)

      expect(response).to eq([200, {}, ["app did /test"]])
    end
  end
end
