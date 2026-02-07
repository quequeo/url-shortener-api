class Visit < ApplicationRecord
  belongs_to :link

  paginates_per 25
  max_paginates_per 100
end
