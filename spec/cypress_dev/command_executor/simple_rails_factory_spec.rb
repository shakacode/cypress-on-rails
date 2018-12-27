require 'cypress_dev/simple_rails_factory'

RSpec.describe CypressDev::SimpleRailsFactory do
  subject { CypressDev::SimpleRailsFactory }

  class AppRecord
    def self.create!(*)
    end
  end

  before { allow(AppRecord).to receive(:create!) }

  it do
    subject.create('AppRecord', { my_args: 'Hello World' })

    expect(AppRecord).to have_received(:create!).with( { my_args: 'Hello World' } )
  end

  it do
    expect{ subject.create('UnknownRecord', { my_args: 'Hello World' }) }.
      to raise_error(NameError)
  end
end
