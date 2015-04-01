require 'test_helper'

class TagsControllerTest < FunctionalTestCase
  setup do
  	@tag = tags(:one)
  end 

  test "should create tag" do
    assert_difference 'Tag.count', 1 do
      post :create, tag: {
        content: @tag.content 
      }
    end
    #assert_redirected_to tag_path(assigns(:tag))
  end

	# test "should get tagify" do
 #  	get :tagify 
 #  	assert_response :success 
	# end 
end
