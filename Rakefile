require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'json'

modname = JSON.parse(open('metadata.json').read)['name'].split('-')[1]

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_parameter_defaults')

task(:default).clear
task :default => [:spec, :lint]

Rake::Task[:spec_prep].clear
desc 'Create the fixtures directory'
task :spec_prep do
  # Allow to test the module with custom dependencies
  # like you could do with .fixtures file
  if ENV['PUPPETFILE']
    puppetfile = ENV['PUPPETFILE']
    if ENV['GEM_HOME']
      gem_home    = ENV['GEM_HOME']
      gem_bin_dir = "#{gem_home}" + '/bin/'
    else
      gem_bin_dir = ''
    end
    r10k = ['env']
    r10k += ["PUPPETFILE=#{puppetfile}"]
    r10k += ["PUPPETFILE_DIR=#{Dir.pwd}/spec/fixtures/modules"]
    r10k += ["#{gem_bin_dir}r10k"]
    r10k += ['puppetfile', 'install', '-v']
    sh(*r10k)
  else
  # otherwise, use official OpenStack Puppetfile
    zuul_ref = ENV['ZUUL_REF']
    zuul_branch = ENV['ZUUL_BRANCH']
    zuul_url = ENV['ZUUL_URL']
    repo = 'openstack/puppet-openstack-integration'
    rm_rf(repo)
    if File.exists?('/usr/zuul-env/bin/zuul-cloner')
      zuul_clone_cmd = ['/usr/zuul-env/bin/zuul-cloner']
      zuul_clone_cmd += ['--cache-dir', '/opt/git']
      zuul_clone_cmd += ['--zuul-ref', "#{zuul_ref}"]
      zuul_clone_cmd += ['--zuul-branch', "#{zuul_branch}"]
      zuul_clone_cmd += ['--zuul-url', "#{zuul_url}"]
      zuul_clone_cmd += ['git://git.openstack.org', "#{repo}"]
      sh(*zuul_clone_cmd)
    else
      sh("git clone https://git.openstack.org/#{repo} -b stable/kilo #{repo}")
    end
    script = ['env']
    script += ["PUPPETFILE_DIR=#{Dir.pwd}/spec/fixtures/modules"]
    script += ["ZUUL_REF=#{zuul_ref}"]
    script += ["ZUUL_BRANCH=#{zuul_branch}"]
    script += ["ZUUL_URL=#{zuul_url}"]
    script += ['bash', "#{repo}/install_modules_unit.sh"]
    sh(*script)
  end
  rm_rf("spec/fixtures/modules/#{modname}")
  ln_s(Dir.pwd, "spec/fixtures/modules/#{modname}")
  mkdir_p('spec/fixtures/manifests')
  touch('spec/fixtures/manifests/site.pp')
end

Rake::Task[:spec_clean].clear
desc 'Clean up the fixtures directory'
task :spec_clean do
  rm_rf('spec/fixtures/modules')
  rm_rf('openstack')
  if File.zero?('spec/fixtures/manifests/site.pp')
    rm_f('spec/fixtures/manifests/site.pp')
  end
end
