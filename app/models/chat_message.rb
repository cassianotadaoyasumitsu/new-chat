class ChatMessage < ApplicationRecord
  belongs_to :document

  validates :role, presence: true
  validates :content, presence: true

  scope :chronological, -> { order(created_at: :asc) }
end
