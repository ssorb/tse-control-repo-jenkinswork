require 'fileutils'

# VARIABLES
# These are common string variables that are used by the build tasks.

ENV['version']                ||= 'dev'
ENV['project_dir']            ||= File.dirname(__FILE__)
ENV['puppetfile']             ||= File.join(ENV['project_dir'], 'Puppetfile')
ENV['build_dir']              ||= File.join(ENV['project_dir'], 'build')
ENV['environment_dir']        ||= File.join(ENV['build_dir'], 'environment')
ENV['modules_dir']            ||= File.join(ENV['environment_dir'], 'modules')
ENV['repos_dir']              ||= File.join(ENV['build_dir'], 'repos')
ENV['control_repo_name']      ||= 'puppet-control'
ENV['control_repo_build_dir'] ||= File.join(ENV['build_dir'], ENV['control_repo_name'])
ENV['offline_puppetfile']     ||= File.join(ENV['build_dir'], 'Puppetfile')
ENV['offline_repos_path']     ||= '/opt/puppet/repos'
ENV['repos_name']             ||= "seteam-production-repos-#{ENV['version']}"
ENV['environment_name']       ||= "seteam-production-#{ENV['version']}"
ENV['repos_tarball']          ||= File.join(ENV['build_dir'], "#{ENV['repos_name']}.tar.gz")
ENV['environment_tarball']    ||= File.join(ENV['build_dir'], "#{ENV['environment_name']}.tar.gz")
ENV['platform_tar_flags']     ||= %x{uname} == 'Darwin' ? '--disable-copyfile' : ''

# TASKS
# These tasks result in actions or artifacts
#

task :default => [:repos_tarball, :environment_tarball]

desc "Create a tarball containing a self-contained version of all repositories needed to run r10k"
task :repos_tarball => ENV['repos_tarball'] do
  puts "repos_tarball task complete"
end

desc "Create a tarball containing an extracted environment (as would be built by r10k)"
task :environment_tarball => ENV['environment_tarball'] do
  puts "environment_tarball task complete"
end

desc "Clean up and remove the build directory"
task :clean do
  rm_rf ENV['build_dir']
end

# FILES
# These define the files Rake tracks and builds
#

file ENV['repos_dir'] => [ENV['modules_dir'], ENV['control_repo_build_dir']] do
  rm_rf ENV['repos_dir']
  mkdir_p ENV['repos_dir']

  Rake::FileList["#{ENV['modules_dir']}/*"].each do |mod_dir|
    mod_name   = File.basename(mod_dir)
    dotgit_dir = File.join(mod_dir, '.git')
    repo_dir   = File.join(ENV['repos_dir'], "#{mod_name}.git")

    git_clone_bare(dotgit_dir, repo_dir)
  end

  control_dotgit_dir = File.join(ENV['control_repo_build_dir'], '.git')
  control_repo_dir   = File.join(ENV['repos_dir'], "#{ENV['control_repo_name']}.git")
  git_clone_bare(control_dotgit_dir, control_repo_dir)
end

file ENV['offline_puppetfile'] => ENV['modules_dir'] do
  File.open(ENV['offline_puppetfile'], 'w') do |file|
    file.write("forge 'forgeapi.puppetlabs.com'\n\n")

    Rake::FileList["#{ENV['modules_dir']}/*"].each do |mod_dir|
      name = File.basename(mod_dir)
      head = File.read(File.join(mod_dir, '.git', 'HEAD')).chomp
      ref  = head.match(%r{^ref: }) ? head.sub(%r{^ref: refs/heads/}, '') : head

      file.write("mod '#{name}',\n")
      file.write("  :git => '#{ENV['offline_repos_path']}/#{name}.git',\n")
      file.write("  :ref => '#{ref}'\n\n")
    end
  end
end

file ENV['control_repo_build_dir'] => ENV['offline_puppetfile'] do
  rm_rf ENV['control_repo_build_dir']
  mkdir ENV['control_repo_build_dir']
  Dir.chdir(ENV['control_repo_build_dir']) do
    sh "git clone '#{File.join(ENV['project_dir'], '.git')}' ."
    sh 'git branch -m production'
    cp ENV['offline_puppetfile'], 'Puppetfile'
    sh 'git add Puppetfile'
    sh 'git commit -m "Lab environment control repo initialized"'
  end
end

file ENV['modules_dir'] => ENV['puppetfile'] do
  rm_rf ENV['environment_dir']
  mkdir_p ENV['environment_dir']
  exclude = [File.basename(ENV['build_dir']), 'modules', '.', '..', '.git']
  Dir.entries(ENV['project_dir']).reject{|e| exclude.include?(e)}.each do |file|
    cp_r(File.join(ENV['project_dir'], file), ENV['environment_dir'], :verbose => true)
  end

  Dir.chdir(ENV['environment_dir']) do
    IO.popen("r10k puppetfile install -v") { |f| puts f.gets }
  end

  # Rake::FileList["#{ENV['modules_dir']}/*"].each do |mod|
  Dir.entries(ENV['modules_dir']).reject{|e| e =~ /^\./}.each do |mod|
    mod_dir    = File.join(ENV['modules_dir'], mod)
    dotgit_dir = File.join(mod_dir, '.git')
    repo_dir   = File.join(ENV['repos_dir'], "#{mod}.git")

    unless File.exist?(dotgit_dir)
      Dir.chdir(mod_dir) do
        sh 'git init .'
        sh 'git add -f *'
        sh 'git commit -m "create new repo from snapshot"'
      end
    end
  end
end

file ENV['environment_tarball'] => ENV['modules_dir'] do
  environment_dir_name = File.basename(ENV['environment_dir'])

  Dir.chdir(ENV['build_dir']) do
    tarflags = [
      ENV['platform_tar_flags'],
      tar_transform_flags(environment_dir_name, ENV['environment_name']),
      '--exclude .git',
      '--exclude .gitignore',
      "-cvzf #{ENV['environment_tarball']}",
      environment_dir_name
    ]

    sh "tar #{tarflags.join(' ')}"
  end
end

file ENV['repos_tarball'] => [ENV['control_repo_build_dir'], ENV['repos_dir']] do
  repos_dir_name = File.basename(ENV['repos_dir'])

  Dir.chdir(ENV['build_dir']) do
    tarflags = [
      ENV['platform_tar_flags'],
      tar_transform_flags(repos_dir_name, ENV['repos_name']),
      "-cvzf #{ENV['repos_tarball']}",
      repos_dir_name
    ]

    sh "tar #{tarflags.join(' ')}"
  end
end

# FUNCTIONS
# Helper routines to capture logic that is required by more than one task
#

def tar_transform_flags(from, to)
  case %x{uname}.chomp
  when 'Darwin'
    "-s /#{from}/#{to}/"
  else
    "--transform='s/#{from}/#{to}/'"
  end
end

def git_clone_bare(from, to)
  sh "git clone --bare --no-hardlinks '#{from}' '#{to}'"
  sh "GIT_DIR='#{to}' git repack -a"
  rm_f(File.join(to, 'objects', 'info', 'alternates'))
end
