# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{libarchive}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["winebarrel"]
  s.date = %q{2010-12-11}
  s.description = %q{Ruby bindings for Libarchive. Libarchive is a programming library that can create and read several different streaming archive formats, including most popular tar variants, several cpio formats, and both BSD and GNU ar variants.}
  s.email = %q{sgwr_dts@yahoo.co.jp}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["README.txt", "libarchive.c", "COPYING.libarchive", "LICENSE.libbzip2"]
  s.files = ["ext/archive_read_support_compression.c", "ext/archive_read_support_compression.h", "ext/archive_read_support_format.c", "ext/archive_read_support_format.h", "ext/archive_write_open_rb_str.c", "ext/archive_write_open_rb_str.h", "ext/archive_write_set_compression.c", "ext/archive_write_set_compression.h", "ext/config.h.in", "ext/configure", "ext/configure.in", "ext/depend", "ext/extconf.rb", "ext/install-sh", "ext/libarchive.c", "ext/libarchive_archive.c", "ext/libarchive_entry.c", "ext/libarchive_internal.h", "ext/libarchive_reader.c", "ext/libarchive_win32.h", "ext/libarchive_writer.c", "ext/Makefile.in", "lib/libarchive.rb", "lib/libarchive_ruby.rb", "README.txt", "libarchive.c", "COPYING.libarchive", "LICENSE.libbzip2"]
  s.homepage = %q{http://libarchive.rubyforge.org}
  s.rdoc_options = ["--title", "Libarchive/Ruby - Ruby bindings for Libarchive."]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{libarchive}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Ruby bindings for Libarchive.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
