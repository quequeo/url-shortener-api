class Visit < ApplicationRecord
  belongs_to :link

  scope :recent, -> { order(created_at: :desc) }

  paginates_per 25
  max_paginates_per 100
end
