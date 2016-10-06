class Admin::PrintFormsController < ApplicationController
  layout 'admin'

  active_scaffold :print_form do |config|
    config.columns[:template_name].form_ui = :select
    templates = Dir["#{RAILS_ROOT}/app/views/print_forms/**/*.erb"].
        select{ |path| File.file?(path) }.
        map { |path| path.gsub("#{RAILS_ROOT}/app/views/print_forms/", '') }
    config.columns[:template_name].options = {:options => templates}

    config.columns[:printable_type].form_ui = :select
    config.columns[:printable_type].options = {:options => PrintForm::PRINTABLE_TYPES }
  end

end