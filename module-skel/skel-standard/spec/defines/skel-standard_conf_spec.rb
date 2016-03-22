require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'skel-standard::conf', :type => :define do

  let(:title) { 'example_skel-standard.conf' }
  let(:node) { 'rspec.getautomation.com' }
  let(:facts) { { :operatingsystem => 'redhat' } }
  let(:params) {
    {'path' => '/tmp/test_config.conf',}
  }

  describe 'Test skel-standard::conf' do
    it 'should create a skel-standard::conf file' do
      should contain_file('example_skel-standard.conf').with_ensure('present')
    end

  end

  describe 'Test skel-standard::conf decommissioning' do
    let(:params) { { 'ensure' => 'absent',} }
    it { should contain_file('example_skel-standard.conf').with_ensure('absent') }
  end

end
