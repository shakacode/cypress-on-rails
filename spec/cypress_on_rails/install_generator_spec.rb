require 'spec_helper'
require 'fileutils'
require 'rails/generators/testing/behaviour'
require 'generators/cypress_on_rails/install_generator'

require 'dummy_app/init'

RSpec::Matchers.define :exist? do
  match do |file|
    expect(File.exist?(file)).to eq(true)
  end
end

RSpec.describe CypressOnRails::InstallGenerator do
  include FileUtils

  let(:dummy_app) { Dummy::Application }
  let(:dummy_assets) { dummy_app.assets }
  let(:dummy_app_root) { File.expand_path('../dummy_app', __dir__) }
  let(:generator) { described_class }

  before(:each) do
    spec_helper_silence_stdout do
      generator.start([], destination_root: dummy_app_root)
    end
  end

  after(:each) do
    rm_rf File.join(dummy_app.config.root, 'vendor')
  end

  let(:cypress_dir) { File.join(dummy_app_root, 'spec', 'cypress') }
  let(:stylesheets_dir) { File.join(dummy_app_root, 'vendor', 'assets', 'stylesheets') }

  describe 'installed files' do
    it 'has actions file' do
      expect(File.join(cypress_dir, 'integration', 'examples', 'actions.spec.js')).to exist?
    end
  end
end

# Silence +STDOUT+ temporarily.
#
# &block:: Block of code to call while +STDOUT+ is disabled.
#
def spec_helper_silence_stdout( &block )
  spec_helper_silence_stream( $stdout, &block )
end

# Back-end to #spec_helper_silence_stdout; silences arbitrary streams.
#
# +stream+:: The output stream to silence, e.g. <tt>$stdout</tt>
# &block::   Block of code to call while output stream is disabled.
#
def spec_helper_silence_stream( stream, &block )
  begin
    old_stream = stream.dup
    stream.reopen( File::NULL )
    stream.sync = true

    yield

  ensure
    stream.reopen( old_stream )
    old_stream.close
  end
end

