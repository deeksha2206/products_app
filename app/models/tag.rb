# frozen_string_literal:true

class Tag < ApplicationRecord
  has_many :product_tags, dependent: :destroy
  has_many :category_tags, dependent: :destroy
  has_many :products, through: :product_tags
  has_many :categories, through: :category_tags
  validates_presence_of :name, :description
end
