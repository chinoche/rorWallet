class Transaction < ApplicationRecord
  validates_presence_of :transferred, :comission, :rate, :total, :created_by, :destination
end