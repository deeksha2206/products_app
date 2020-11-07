# frozen_string_literal:true

class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
end
