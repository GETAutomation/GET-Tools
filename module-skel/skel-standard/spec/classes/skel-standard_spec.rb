require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'skel-standard' do
  let(:title) { 'skel-standard' }
  let(:node) { 'rspec.get-automation.com' }
  let(:facts) { { :ipaddress => '10.21.21.21' } }
  let(:facts) { { :operatingsystem => 'RedHat'} }

  describe 'On an unknown OS with no package name specified' do
    let(:facts) { {:operatingsystem => 'GitOS'} }
    it do
      expect { should raise_error(Puppet::Error) }
    end
  end

  describe 'Test standard installation' do
    it { should contain_package('skel-standard.package').with_ensure('present') }
    it { should contain_service('skel-standard').with_ensure('running') }
    it { should contain_service('skel-standard').with_enable('true') }
    it { should contain_file('skel-standard.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.6.21' } }
    it { should contain_package('skel-standard.package').with_ensure('1.6.21') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true} }
    it 'should remove Package[skel-standard]' do should contain_package('skel-standard.package').with_ensure('absent') end
    it 'should stop Service[skel-standard]' do should contain_service('skel-standard').with_ensure('stopped') end
    it 'should not enable at boot Service[skel-standard]' do should contain_service('skel-standard').with_enable('false') end
    it 'should remove skel-standard configuration file' do should contain_file('skel-standard.conf').with_ensure('absent') end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true} }
    it { should contain_package('skel-standard.package').with_ensure('present') }
    it 'should stop Service[skel-standard]' do should contain_service('skel-standard').with_ensure('stopped') end
    it 'should not enable at boot Service[skel-standard]' do should contain_service('skel-standard').with_enable('false') end
    it { should contain_file('skel-standard.conf').with_ensure('present') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true} }
    it { should contain_package('skel-standard.package').with_ensure('present') }
    it { should_not contain_service('skel-standard').with_ensure('present') }
    it { should_not contain_service('skel-standard').with_ensure('absent') }
    it 'should not enable at boot Service[skel-standard]' do should contain_service('skel-standard').with_enable('false') end
    it { should contain_file('skel-standard.conf').with_ensure('present') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('skel-standard.package').with_noop('true') }
    it { should contain_service('skel-standard').with_noop('true') }
    it { should contain_file('skel-standard.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "skel-standard/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      should contain_file('skel-standard.conf').with_content(/rspec.get-automation.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('skel-standard.conf').with_content(/value_a/)
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => 'puppet:///modules/skel-standard/spec'} }
    it { should contain_file('skel-standard.conf').with_source('puppet:///modules/skel-standard/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/skel-standard/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('skel-standard.dir').with_source('puppet:///modules/skel-standard/dir/spec') }
    it { should contain_file('skel-standard.dir').with_purge('true') }
    it { should contain_file('skel-standard.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:extend => "skel-standard::spec" } }
    it { should contain_file('skel-standard.conf').with_content(/rspec.get-automation.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => false } }
    it { should contain_file('skel-standard.conf').with_notify }
  end


end

