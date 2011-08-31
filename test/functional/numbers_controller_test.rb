require 'test_helper'

class NumbersControllerTest < ActionController::TestCase
  setup do
    @number = numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create number" do
    assert_difference('Number.count') do
      post :create, :number => @number.attributes
    end

    assert_redirected_to number_path(assigns(:number))
  end

  test "should show number" do
    get :show, :id => @number.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @number.to_param
    assert_response :success
  end

  test "should update number" do
    put :update, :id => @number.to_param, :number => @number.attributes
    assert_redirected_to number_path(assigns(:number))
  end

  test "should destroy number" do
    assert_difference('Number.count', -1) do
      delete :destroy, :id => @number.to_param
    end

    assert_redirected_to numbers_path
  end
end
