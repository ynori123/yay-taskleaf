class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  before_validation :set_nameless_name

  private
    def validate_name_not_including_comma
      errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
    end
  
  private
    def set_nameless_name
      self.name = '名前なし' if name.blank?
    end
end
