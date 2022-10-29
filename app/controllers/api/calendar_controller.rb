class Api::CalendarController < ActionController::API
  def show
    @study_time_records = User.find(params[:id])
                              .study_time_records
  end
end
