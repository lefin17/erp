module PersonsHelper
  def persons_for_select(client_id)
    Person.persons_of_client(client_id).map { |s| [s.fio,s.id]  }
  end

  def hlp_persons_of_client(client_id)
    Person.persons_of_client(client_id).map
  end

end
