class Visit < ApplicationRecord
  belongs_to :link

  MAX_VISITS_PER_PAGE = 100

  def self.per_page
    MAX_VISITS_PER_PAGE
  end
end
