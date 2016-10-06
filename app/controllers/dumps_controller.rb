class DumpsController < ApplicationController
  layout 'admin'
  
  def index
    @dumps = Dump.paginate :order => "created_at desc", :page => params[:page]
  end

  def show
    dump = Dump.find(params[:id])
    send_file "#{dump.filename}"
  end

  def new
    @dump = Dump.new
    @tables = Dump.connection.select_values("SHOW TABLES")
  end

  def create
    @dump = Dump.new(params[:dump].update(:user_id => @g_user.id, :status => 'new'))
    if @dump.save
      redirect_to(dumps_path, :notice => 'Dump базы подготавливается. Вы получите уедомление на email как только он будет готов.')
    else
      render :action => "new"
    end
  end

  def destroy
    @dump = Dump.find(params[:id])
    @dump.destroy

    redirect_to(dumps_url)
  end
end
