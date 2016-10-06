# To change this template, choose Tools | Templates
# and open the template in the editor.

class Mail < ActionMailer::Base

  def event_task_performed(task)
    recipients task.from_user.email
    from "Polygraph ERP <no-reply@artpolygraf.ru>"
    subject "Отчет о выполненой задаче"
    content_type 'text/html'
    body :task => task
  end

  def dump_ready(dump)
    user = User.find(dump.user_id)
    recipients user.email
    from "no-reply@artpolygraf.ru"
    subject "Заказанный вами dump готов."
    body :user => user, :dump => dump
  end

end
