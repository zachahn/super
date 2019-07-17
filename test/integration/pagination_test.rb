require "test_helper"

class PaginationTest < CapybaraTest
  setup do
    @original_index_resources_per_page = Super.configuration.index_resources_per_page

    Super.configuration.index_resources_per_page = 3

    Member.delete_all

    # Page 1
    Member.create!(name: "James Kirk", rank: "Captain")
    Member.create!(name: "Spock", rank: "Commander")
    Member.create!(name: "Leonard McCoy", rank: "Commander")

    # Page 2
    Member.create!(name: "Montgomery Scott", rank: "Lieutenant Commander")
    Member.create!(name: "Nyota Uhura", rank: "Lieutenant Commander")
    Member.create!(name: "Pavel Chekov", rank: "Ensign")

    # Page 3
    Member.create!(name: "Christine Chapel", rank: "Lieutenant")
    Member.create!(name: "Hikaru Sulu", rank: "Lieutenant")
  end

  teardown do
    Super.configuration.index_resources_per_page = @original_index_resources_per_page
  end

  def test_three_members_on_first_page
    visit(admin_members_path)

    assert_equal(3, page.find_all("tbody tr").size)
    assert(page.has_content?("James Kirk"))
    assert(page.has_content?("Spock"))
    assert(page.has_content?("Leonard McCoy"))
  end

  def test_three_members_on_second_page
    visit(admin_members_path)
    click_on("2")

    assert_equal(3, page.find_all("tbody tr").size)
    assert(page.has_content?("Montgomery Scott"))
    assert(page.has_content?("Nyota Uhura"))
    assert(page.has_content?("Pavel Chekov"))
  end

  def test_one_user_on_last_page
    visit(admin_members_path)
    click_on("3")

    assert_equal(2, page.find_all("tbody tr").size)
    assert(page.has_content?("Christine Chapel"))
    assert(page.has_content?("Hikaru Sulu"))
  end
end