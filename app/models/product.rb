# frozen_string_literal:true

class Product < ApplicationRecord
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  validates_presence_of :name, :brand, :price, :description
  accepts_nested_attributes_for :tags, allow_destroy: true
end
