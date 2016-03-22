# Acceptance Tests for skel-package
# README:
# Unlike the unit tests which only test compilation and a puppet run,
# they do not cover a more real world scenario. As such you cannot 
# pass bogus information into the parameters or versions
require 'spec_helper_acceptance'

# This should reflect what you have in params.pp
# Meaning these should be REAL values.
case fact('operatingsystem')
  when /(?i:RedHat|OracleLinux|CentOS)/
    enforced_package                     = 'skel-package'
    enforced_package_version             = '5.5'
end


# Standard Installation, accepting default options
describe 'skel-package Class - Standard Installation' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'skel-package': }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed }
  end
end

# Standard Installation, Specific Version Required
describe 'skel-package Class - Installation of a specific verion' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'skel-package': 
      version => "#{enforced_package_version}"
    }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed.with_version("#{enforced_package_version}") }
  end
end
