class DialogsController < ApplicationController
  def dialogshow
    case params[:dialogtype]
    when 'client'
      @dialogtemplate = "dialogs/client/#{params[:dialogtype]}"
    when 'person'
      @dialogtemplate = "dialogs/person/#{params[:dialogtype]}"
    end
  end

  def dialogselect
    @id = params[:id]
  end

  def get_persons
    @persons = Person.joined.like_fio(params[:f_fio]).like_client(params[:f_client]).like_email(params[:f_email]).like_phone(params[:f_phone])
  end

  def get_clients
    @clients = User.clients.like_name(params[:f_name]).
      like_ur(params[:f_ur]).
      like_email(params[:f_email]).
      like_phone(params[:f_phone])
  end

end
