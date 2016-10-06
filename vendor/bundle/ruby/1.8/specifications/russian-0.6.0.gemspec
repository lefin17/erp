# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{russian}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yaroslav Markin"]
  s.autorequire = %q{russian}
  s.date = %q{2011-10-23}
  s.description = %q{Russian language support for Ruby and Rails}
  s.email = %q{yaroslav@markin.net}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.files = ["lib/russian/action_view_ext/helpers/date_helper.rb", "lib/russian/active_model_ext/custom_error_message.rb", "lib/russian/locale/actionview.yml", "lib/russian/locale/activemodel.yml", "lib/russian/locale/activerecord.yml", "lib/russian/locale/activesupport.yml", "lib/russian/locale/datetime.rb", "lib/russian/locale/datetime.yml", "lib/russian/locale/pluralization.rb", "lib/russian/locale/transliterator.rb", "lib/russian/russian_rails.rb", "lib/russian/transliteration.rb", "lib/russian/version.rb", "lib/russian.rb", "spec/fixtures/en.yml", "spec/fixtures/ru.yml", "spec/i18n/locale/datetime_spec.rb", "spec/i18n/locale/pluralization_spec.rb", "spec/locale_spec.rb", "spec/russian_spec.rb", "spec/spec_helper.rb", "spec/transliteration_spec.rb", "CHANGELOG", "Gemfile", "LICENSE", "Rakefile", "README.textile", "russian.gemspec", "TODO"]
  s.homepage = %q{http://github.com/yaroslav/russian/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Russian language support for Ruby and Rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>, [">= 0.5.0"])
      s.add_development_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7.0"])
    else
      s.add_dependency(%q<i18n>, [">= 0.5.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7.0"])
    end
  else
    s.add_dependency(%q<i18n>, [">= 0.5.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7.0"])
  end
end
