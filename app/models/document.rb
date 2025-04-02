class Document < ApplicationRecord
  has_one_attached :pdf_file
  has_many :chat_messages, dependent: :destroy

  validates :title, presence: true
  validate :pdf_file_validation

  private

  def pdf_file_validation
    if pdf_file.attached?
      unless pdf_file.content_type.in?('application/pdf')
        errors.add(:pdf_file, 'must be a PDF file')
      end
    end
  end
end
