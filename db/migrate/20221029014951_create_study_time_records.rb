class CreateStudyTimeRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :study_time_records do |t|
      t.references :user, foreign_key: true
      t.time :start_at
      t.time :end_at

      t.timestamps
    end
  end
end
