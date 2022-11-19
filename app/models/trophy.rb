class Trophy < ApplicationRecord
  belongs_to :question

  validates_presence_of :name

  has_one_attached :image
end
