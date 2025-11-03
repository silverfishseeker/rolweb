require "application_system_test_case"

class ContextolootsTest < ApplicationSystemTestCase
  setup do
    @contextoloot = contextoloots(:one)
  end

  test "visiting the index" do
    visit contextoloots_url
    assert_selector "h1", text: "Contextoloots"
  end

  test "should create contextoloot" do
    visit contextoloots_url
    click_on "New contextoloot"

    fill_in "Nombre", with: @contextoloot.nombre
    click_on "Create Contextoloot"

    assert_text "Contextoloot was successfully created"
    click_on "Back"
  end

  test "should update Contextoloot" do
    visit contextoloot_url(@contextoloot)
    click_on "Edit this contextoloot", match: :first

    fill_in "Nombre", with: @contextoloot.nombre
    click_on "Update Contextoloot"

    assert_text "Contextoloot was successfully updated"
    click_on "Back"
  end

  test "should destroy Contextoloot" do
    visit contextoloot_url(@contextoloot)
    click_on "Destroy this contextoloot", match: :first

    assert_text "Contextoloot was successfully destroyed"
  end
end
