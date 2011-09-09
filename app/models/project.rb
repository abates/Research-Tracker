class Project < ActiveRecord::Base
  textile :description

  has_many :notes, :as => :notable
  has_and_belongs_to_many :papers

  def to_s
    name
  end
end
