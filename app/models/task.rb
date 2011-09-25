class Task < ActiveRecord::Base
  belongs_to :project
  has_many :notes, :as => :notable
  textile :description

  def percent_complete
    p = read_attribute(:percent_complete)
    (p.nil? || p.blank? ? 0 : p)
  end
end


