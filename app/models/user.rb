class User < ActiveRecord::Base
  validates :agreement, acceptance: true
  validates :email, confirmation: true
end
