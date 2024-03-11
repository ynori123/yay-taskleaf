class Task < ApplicationRecord
  has_one_attached :image
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  before_validation :set_nameless_name

  belongs_to :user, foreign_key: "user_id"

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at name] # 検索可能にしたい属性をここに追加します
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
    def validate_name_not_including_comma
      errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
    end
  
  private
    def set_nameless_name
      self.name = '名前なし' if name.blank?
    end
end
