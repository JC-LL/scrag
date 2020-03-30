require_relative "./lib/scrag/version"

Gem::Specification.new do |s|
  s.name        = 'scrag'
  s.version     = Scrag::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Scrag : scaffolding tool for my DSL compilers"
  s.description = "Helps me design my DSL tools quicker"
  s.authors     = ["Jean-Christophe Le Lann"]
  s.email       = 'lelannje@ensta-bretagne.fr'
  s.files       = [
                    "lib/scrag/runner.rb",
                    "lib/scrag/compiler.rb",
                    "lib/scrag/code.rb",
                    "lib/scrag/version.rb",
                    "lib/scrag.rb",
                ]
  s.files       += Dir["lib/templates/*.erb"]
  s.executables << 'scrag'
  s.homepage    = 'https://github.com/JC-LL/scrag'
  s.license     = 'MIT'
  s.post_install_message = "Thanks for installing ! Homepage :https://github.com/JC-LL/scrag"
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency 'colorize', '0.8.1'

end
