# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{activeresource}
  s.version = "2.3.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.autorequire = %q{active_resource}
  s.date = %q{2011-02-08}
  s.description = %q{Wraps web resources in model classes that can be manipulated through XML over REST.}
  s.email = %q{david@loudthinking.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = %q{http://www.rubyonrails.org}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{activeresource}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Think Active Record for web resources.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 2.3.11"])
    else
      s.add_dependency(%q<activesupport>, ["= 2.3.11"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 2.3.11"])
  end
end
