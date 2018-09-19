class Customer < ApplicationRecord
  has_many :orders

  default_scope {order("created_at DESC")}
end
