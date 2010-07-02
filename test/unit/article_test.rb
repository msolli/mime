require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  should "be valid" do
    assert Article.new.valid?
  end
end
