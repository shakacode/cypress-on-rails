require 'cypress_on_rails/smart_factory_wrapper'

RSpec.describe CypressOnRails::SmartFactoryWrapper do
  FileSystemDummy = Struct.new(:file_hash) do
    def mtime(filename)
      file_hash.fetch(filename)
    end
  end

  let(:time_now) { Time.now }
  let(:mtime_hash) { {'file1.rb' => time_now, 'file2.rb' => time_now } }
  let(:files) { %w(file1.rb file2.rb) }
  let(:factory_double) { double('FactoryBot', create: true, create_list: true) }
  let(:factory_cleaner) { class_double(CypressOnRails::SmartFactoryWrapper::FactoryCleaner, clean: true) }
  let(:kernel_double) { class_double(Kernel, load: true) }
  let(:file_double) { FileSystemDummy.new(mtime_hash) }
  let(:dir_double) { class_double(Dir) }

  before do
    allow(Dir).to receive(:[]).with(*files) { mtime_hash.keys }
  end

  subject do
    described_class.new(files: files,
                        factory: factory_double,
                        kernel: kernel_double,
                        file_system: file_double,
                        dir_system: dir_double,
                        factory_cleaner: factory_cleaner)
  end

  it 'loads all the files on first create it' do
    subject.create(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb')
    expect(kernel_double).to have_received(:load).with('file2.rb')
  end

  it 'loads all the files on first create_list ' do
    subject.create_list(:user, 10)
    expect(kernel_double).to have_received(:load).with('file1.rb')
    expect(kernel_double).to have_received(:load).with('file2.rb')
  end

  it 'it sends delegates create to the factory' do
    subject.create(:user)
    expect(factory_double).to have_received(:create).with(:user)
  end

  it 'it sends delegates create_list to the factory' do
    subject.create_list(:note, 10)
    expect(factory_double).to have_received(:create_list).with(:note, 10)
  end

  it 'wont load the files if they have not changed' do
    subject.create(:user)
    subject.create_list(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').once
    expect(kernel_double).to have_received(:load).with('file2.rb').once
  end

  it 'will reload the files if any have changed' do
    subject.create(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').once
    expect(kernel_double).to have_received(:load).with('file2.rb').once

    mtime_hash['file1.rb'] = Time.now
    subject.create_list(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').twice
    expect(kernel_double).to have_received(:load).with('file2.rb').twice
  end

  it 'will reload only the files that exist' do
    subject.always_reload = true
    subject.create(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').once
    expect(kernel_double).to have_received(:load).with('file2.rb').once

    mtime_hash.delete('file1.rb')
    subject.create_list(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').once
    expect(kernel_double).to have_received(:load).with('file2.rb').twice
  end

  it 'will reset factory if a has changed' do
    subject.create(:user)
    expect(factory_cleaner).to have_received(:clean).with(factory_double)

    mtime_hash['file1.rb'] = Time.now
    subject.create_list(:user)

    expect(factory_cleaner).to have_received(:clean).with(factory_double).twice
  end

  it 'will always reload the files enabled' do
    subject.always_reload = true
    subject.create_list(:user)
    subject.create(:user)
    expect(kernel_double).to have_received(:load).with('file1.rb').twice
    expect(kernel_double).to have_received(:load).with('file2.rb').twice
  end

  context 'files is a string' do
    let(:files) { 'file*.rb' }

    before do
      allow(Dir).to receive(:[]).with('file*.rb') { mtime_hash.keys }
    end

    it 'loads all the files on first create it' do
      subject.create(:user)
      expect(kernel_double).to have_received(:load).with('file1.rb')
      expect(kernel_double).to have_received(:load).with('file2.rb')
    end
  end
end
