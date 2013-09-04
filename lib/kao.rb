require 'kao/version'
require 'thor'
require 'pathname'
require 'open3'

module Kao
  class Config
    def root
      if ENV['KAO_HOME']
        Pathname.new(ENV['KAO_HOME'])
      else
        Pathname.new(ENV['HOME']) + '.kao'
      end
    end

    def repo
      root + 'repo'
    end
  end

  class CLI < Thor
    no_commands do
      def config
        @config ||= Config.new
      end

      def files
        run_git('ls-files', '-z', '*.txt', :capture => true)
          .split(/\0/).map do |filename|
            config.repo + filename
          end
      end

      def run_git(*args)
        option = if args.last.kind_of?(Hash) then args.pop else {} end

        command = ['git'] + args.map { |a| a.to_s }
        Dir.chdir(option[:nochdir] ? Dir.pwd : config.repo.to_s) do
          if option[:capture]
            out, s = Open3.capture2(*command)
            abort unless s.success?
            out
          else
            system(*command) or abort
          end
        end
      end
    end

    desc 'init [<url>]', 'initialize local kao repository'
    def init(url=nil)
      if url
        run_git(:clone, url, config.repo, { :nochdir => true })
      else
        run_git(:init, config.repo, { :nochdir => true })
      end
    end

    desc 'git <command> <args>...', 'executes git on local kao repository'
    def git(*args)
      run_git(*args)
    end

    desc 'add [-m] <kao> <kao>...', 'add new kao'
    option :multiline, :type => :boolean, :aliases => [:m]
    def add(*kaoes)
      count = 0
      file = files.first || 'kao.txt'
      file.open('a') do |io|
        if options[:multiline]
          STDIN.each_line do |kao|
            io.puts kao
            count += 1
            kaoes << kao
          end
        else
          kaoes.each do |kao|
            io.puts kao
            count += 1
          end
        end
      end
      run_git :commit, '-a', '-m', "added #{kaoes.join(',')}"
    end

    desc 'list', 'show kao list'
    def list
      files.each do |file|
        File.open(file) do |io|
          io.each_line do |line|
            puts line
          end
        end
      end
    end
  end
end
