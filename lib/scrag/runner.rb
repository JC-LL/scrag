require "optparse"
require "colorize"

require_relative "compiler"

module Scrag

  class Runner

    def self.run *arguments
      new.run(arguments)
    end

    def run arguments
      compiler=Compiler.new
      compiler.options = options = parse_options(arguments)
      if project=options[:project_name]
        compiler.compile project
      end
    end

    def header
      puts "Scrag : scaffolding Ruby compilers (#{VERSION})- (c) JC Le Lann 20"
    end

    private
    def parse_options(arguments)
      header

      parser = OptionParser.new

      options = {}

      parser.on("-h", "--help", "Show help message") do
        puts parser
        print_help_message
        exit(true)
      end

      parser.on("--vv", "verbose") do
        options[:verbose] = true
      end

      parser.on("--force", "force creation, even if file structure already exists") do
        options[:force] = true
      end

      parser.on("-v", "--version", "Show version number") do
        puts VERSION
        exit(true)
      end

      parser.parse!(arguments)

      options[:project_name]=arguments.shift #the remaining c file

      unless options[:project_name]
        puts parser
        print_help_message
      end

      options
    end

    def print_help_message
      puts
      puts "simply enter your project name like > scrag my_dsl".green
      puts
    end
  end
end
