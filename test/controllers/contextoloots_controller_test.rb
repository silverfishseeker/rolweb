require "test_helper"

class ContextolootsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contextoloot = contextoloots(:one)
  end

  test "should get index" do
    get contextoloots_url
    assert_response :success
  end

  test "should get new" do
    get new_contextoloot_url
    assert_response :success
  end

  test "should create contextoloot" do
    assert_difference("Contextoloot.count") do
      post contextoloots_url, params: { contextoloot: { nombre: @contextoloot.nombre } }
    end

    assert_redirected_to contextoloot_url(Contextoloot.last)
  end

  test "should show contextoloot" do
    get contextoloot_url(@contextoloot)
    assert_response :success
  end

  test "should get edit" do
    get edit_contextoloot_url(@contextoloot)
    assert_response :success
  end

  test "should update contextoloot" do
    patch contextoloot_url(@contextoloot), params: { contextoloot: { nombre: @contextoloot.nombre } }
    assert_redirected_to contextoloot_url(@contextoloot)
  end

  test "should destroy contextoloot" do
    assert_difference("Contextoloot.count", -1) do
      delete contextoloot_url(@contextoloot)
    end

    assert_redirected_to contextoloots_url
  end
end
