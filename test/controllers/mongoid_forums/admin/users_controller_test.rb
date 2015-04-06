require 'test_helper'

module MongoidForums
  class Admin::UsersControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end

  end
end
