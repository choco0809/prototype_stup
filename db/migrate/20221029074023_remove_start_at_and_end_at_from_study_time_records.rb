class RemoveStartAtAndEndAtFromStudyTimeRecords < ActiveRecord::Migration[7.0]
  def up
    remove_column :study_time_records, :start_at
    remove_column :study_time_records, :end_at
  end

  def down
    add_column :study_time_records, :start_at, :datetime
    add_column :study_time_records, :end_at, :datetime
  end
end
