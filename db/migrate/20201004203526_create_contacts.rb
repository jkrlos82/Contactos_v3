class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.date :dob
      t.string :telephone
      t.string :address
      t.text :credit_card_ciphertext
      t.text :last_four
      t.string :franchise
      t.string :email
      t.integer :user_id

      t.timestamps
    end
  end
end
