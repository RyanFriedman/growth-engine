require 'test_helper'

module Growth
  class StatsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get stats_index_url
      assert_response :success
    end

  end
end
