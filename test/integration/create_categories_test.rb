require 'test_helper'

# create categories integration test
class CreateCategoriesTest < ActionDispatch::IntegrationTest

  test "get new category form and create category" do
    # 1 ) get new category path # run rake test
    get new_category_path
    # 2 ) assert the form template
    assert_template 'categories/new'
    # 3 ) create a category and display somewhere
    assert_difference 'Category.count', 1 do
      # a. post via redirect after form submission create action
      post_via_redirect categories_path, category: {name: "sports"}
    end
    # 4 ) where do we send user after category is created using post action ?
    assert_template 'categories/index'
    # 5 ) validate that category was created and display to body of page
    assert_match "sports", response.body
  end

  test "invalid category submission results in failure" do
    get new_category_path
    assert_template 'categories/new'
    # check for no change in category count
    assert_no_difference 'Category.count' do
      post categories_path, category: {name: " "}
    end
    assert_template 'categories/new'
    # ensure valiation messages are showing up.
    # Look for the title and body from errors partial *app/view/shared/_errors.html.erb and reference elements
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
