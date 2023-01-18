class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.string :state
      t.string :commit
      t.boolean :check_passed, null: false, default: false
      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
