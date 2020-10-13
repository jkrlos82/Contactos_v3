require 'test_helper'

class UploadFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get upload_files_index_url
    assert_response :success
  end

  test "should get new" do
    get upload_files_new_url
    assert_response :success
  end

end
