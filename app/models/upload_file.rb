class UploadFile < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_one_attached :doc

  def read_file(params) 
    
  end

  def get_franchise(card_number)
    
  end
  
  def encrypt_card(card_number)
    
  end

  def last_four(card_number)
    
  end  

  private
  def validate_fields
    
  end

end
