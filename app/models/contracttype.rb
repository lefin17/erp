class Contracttype < ActiveRecord::Base
  has_many :users
  
  before_save :setdefaultvalue

  named_scope :getdefaultfield, {:conditions => 'isdefault = true'}

  def setdefaultvalue
    if self[:isdefault]
      Contracttype.update_all 'isdefault=false'
    end
  end

end
