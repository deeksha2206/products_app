# frozen_string_literal:true

class Category < ApplicationRecord
  has_many :category_tags, dependent: :destroy
  has_many :tags, through: :category_tags
  has_many :products, through: :tags
  validates_presence_of :name, :description
end
