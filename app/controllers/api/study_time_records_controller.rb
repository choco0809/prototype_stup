class Api::StudyTimeRecordsController < ActionController::API
  include SessionsHelper

  def destroy
    User.find(current_user.id).study_time_records.find(params[:id]).destroy
    head :no_content
  end
end

