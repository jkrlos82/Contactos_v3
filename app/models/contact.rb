class Contact < ApplicationRecord
  belongs_to :user
  encrypts :credit_card
end
