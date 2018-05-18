require_relative '../../lib/cypress/command_executor'

class DummyTest
  # @return [Array]
  def self.values
    @values ||= []
  end
end

RSpec.describe Cypress::CommandExecutor do
  describe '.load' do
    subject { described_class }

    def executor_load(*values)
      subject.load(*values)
    end

    before do
      DummyTest.values.clear
    end

    it 'runs test command' do
      executor_load("#{__dir__}/test_command.rb")
      expect(DummyTest.values).to eq(['hello'])
    end

    it 'runs test command twice' do
      executor_load("#{__dir__}/test_command.rb")
      executor_load("#{__dir__}/test_command.rb")
      expect(DummyTest.values).to eq(['hello', 'hello'])
    end

    it 'runs command with options' do
      executor_load("#{__dir__}/test_command_with_options.rb", 'my_string')
      expect(DummyTest.values).to eq(['my_string'])
    end
  end
end
