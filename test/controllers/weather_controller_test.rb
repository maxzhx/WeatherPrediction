require 'test_helper'

class WeatherControllerTest < ActionController::TestCase
  test "should get locations" do
    get :locations
    assert_response :success
  end

  test "should get data" do
    get :data
    assert_response :success
  end

  test "should get prediction" do
    get :prediction
    assert_response :success
  end

end
