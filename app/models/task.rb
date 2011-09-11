class Task < ActiveRecord::Base
  belongs_to :project
  has_many :notes, :as => :notable
  textile :description
end
