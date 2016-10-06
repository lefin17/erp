class PrintFormsController < ApplicationController
  before_filter :find_print_form
  before_filter :find_printable_object

  layout 'print'

  def print
    self.instance_variable_set("@#{@form.printable_type.tableize.singularize}".to_sym, @object)
    render :action => @form.template_name
  end

  private
    def find_print_form
      @form = PrintForm.find params[:form_id]
      raise ActiveRecord::RecordNotFound.new unless @form.can_be_used_by?(current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to_with_flash root_path, {:alert => 'Неверно указана печатная форма.', :status => 404}
    end

    def find_printable_object
      @object = @form.printable_type.constantize.find_by_id params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to_with_flash root_path, {:alert => 'Не удалось найти объект для печати.', :status => 404}
    end

end