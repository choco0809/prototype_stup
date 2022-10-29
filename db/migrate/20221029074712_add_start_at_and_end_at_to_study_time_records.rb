class AddStartAtAndEndAtToStudyTimeRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :study_time_records, :start_at, :datetime
    add_column :study_time_records, :end_at, :datetime
  end
end
