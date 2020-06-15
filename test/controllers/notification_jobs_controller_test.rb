require 'test_helper'

class NotificationJobsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get notification_jobs_new_url
    assert_response :success
  end

end
