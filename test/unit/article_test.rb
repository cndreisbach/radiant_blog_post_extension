require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
  context "An Article model" do
    setup do
      @article = Article.new
    end

    should "have columns" do
      assert Article.respond_to? :columns
      assert @article.respond_to? :title
      assert @article.respond_to? :summary
      assert @article.respond_to? :full_text
      assert @article.respond_to? :url
      assert @article.respond_to? :parent_id
    end
  end
end
