class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :user
      t.references :answer, index: true

      t.timestamps
    end
  end
end
