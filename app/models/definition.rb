class Definition < ActiveRecord::Base
  belongs_to :term
  textile :text
end
