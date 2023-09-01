class Gender < ApplicationRecord
  has_many :users

  def to_s
    value
  end
end
