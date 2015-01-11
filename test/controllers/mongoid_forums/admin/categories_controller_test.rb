require 'test_helper'

module MongoidForums
  class Admin::CategoriesControllerTest < ActionController::TestCase
    test "should get new" do
      get :new
      assert_response :success
    end

    test "should get create" do
      get :create
      assert_response :success
    end

    test "should get edit" do
      get :edit
      assert_response :success
    end

    test "should get update" do
      get :update
      assert_response :success
    end

    test "should get destroy" do
      get :destroy
      assert_response :success
    end

  end
end
