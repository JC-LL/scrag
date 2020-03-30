require 'erb'
require_relative 'code'

module Scrag

  class Compiler

    attr_accessor :options
    attr_accessor :project_name

    def initialize options={}
      @options=options
    end

    def compile project_name
      @project_name=project_name.downcase
      puts "project #{project_name}".center(65,'=')
      @files_for_dir={
        project_name          => [:gemspec],
        "bin"                 => [:exec],
        "lib"                 => [:top_module],
        "lib/#{project_name}" => [
                                  :ast,
                                  :code,
                                  :compiler,
                                  :exec,
                                  :generic_lexer,
                                  :generic_parser,
                                  :lexer,
                                  :parser,
                                  :pretty_printer,
                                  :runner,
                                  :token,
                                  :top_module,
                                  :transformer,
                                  :version,
                                  :visitor,
                                ]
      }
      generate
    end

    def item n=0,str
      subitem=(n==0) ? "": "  "
      spaces=case n
      when 0 then 0
      when 1 then 1
      else
        1+(n-1)*4
      end

      puts " "*spaces+"#{subitem}[+] #{str}"
    end

    def generate
      @pwd=Dir.pwd
      check_doesnt_exists(project_name)
      create "#{project_name}"
      create "#{project_name}/bin"
      create "#{project_name}/lib"
      create "#{project_name}/lib/#{project_name}"
      create "#{project_name}/tests"
    end

    def create dir
      item "creating dir '#{dir}'"
      create_stuff dir
    end

    def check_doesnt_exists dir
      if Dir.exists?(dir)
        if options[:force]
          puts "WARNING : project already exists !"
          puts "Are you sure you want to force generation ? files will be lost !"
          key=$stdin.chomp
          puts key
        else
          puts "Scrag ERROR : project '#{project_name}' already exists. Type -v for options."
          abort
        end
      end
    end

    def create_stuff dir
      Dir.mkdir dir
      Dir.chdir dir
      rel_dir=dir.split('/')[1..-1].join('/')
      files_to_create=@files_for_dir[rel_dir]
      if files_to_create
        files_to_create.each do |file|
          create_file(file)
        end
      end
      Dir.chdir @pwd
    end

    SPECIALS=[:top_module,:exec,:gemspec]
    def create_file file

      gen_file=(SPECIALS.include?(file)) ? project_name : file
      ext=case file
      when :exec    then ""
      when :gemspec then ".gemspec"
      else ".rb"
      end
      item 1,"creating file '#{gen_file}'"
      template=load_template(file)
      renderer=ERB.new(template)
      gen_code=renderer.result(binding)
      code=Code.new(gen_code)
      code.save_as "#{gen_file}#{ext}",verbose=false
    end

    def load_template file
      template="#{__dir__}/../templates/#{file}.erb"
      template_str=IO.read template
    end
  end
end
