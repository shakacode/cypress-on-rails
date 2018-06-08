require 'cypress_dev/command_executor'

RSpec.describe CypressDev::CommandExecutor do
  describe '.load' do
    let(:folder) { "#{__dir__}/command_executor" }
    subject { described_class }

    def executor_load(*values)
      subject.load(*values)
    end

    before do
      CypressDev.configuration.cypress_folder = folder
      DummyTest.values.clear if defined?(DummyTest)
    end

    it 'runs test command' do
      executor_load("#{folder}/test_command.rb")
      expect(DummyTest.values).to eq(%w(hello))
    end

    it 'runs test command twice' do
      executor_load("#{folder}/test_command.rb")
      executor_load("#{folder}/test_command.rb")
      expect(DummyTest.values).to eq(%w(hello hello))
    end

    it 'runs command with options' do
      executor_load("#{folder}/test_command_with_options.rb", 'my_string')
      expect(DummyTest.values).to eq(%w(my_string))
    end
  end
end
