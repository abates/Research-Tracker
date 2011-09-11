class Project < ActiveRecord::Base
  textile :description

  has_many :notes, :as => :notable
  has_and_belongs_to_many :papers
  has_many :tasks

  def to_s
    name
  end
end
