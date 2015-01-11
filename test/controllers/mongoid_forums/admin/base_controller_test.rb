require 'test_helper'

module MongoidForums
  class Admin::BaseControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end

  end
end
