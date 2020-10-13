class CreateUploadFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :upload_files do |t|
      t.string :status
      t.text :file_errors
      t.integer :user_id

      t.timestamps
    end
  end
end
