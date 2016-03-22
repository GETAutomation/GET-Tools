require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'skel-package' do

  let(:title) { 'skel-package' }
  let(:node) { 'rspec.get-automation.com' }
  let(:facts) { { :ipaddress => '10.21.21.21' } }
  let(:facts) { { :operatingsystem => 'RedHat'} }

  describe 'Test minimal installation' do
    it { should contain_package('skel-package.package').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.6.21' } }
    it { should contain_package('skel-package.package').with_ensure('1.6.21') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[skel-package]' do
      should contain_package('skel-package.package').with_ensure('absent')
    end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('skel-package.package').with_noop('true') }
  end

end
