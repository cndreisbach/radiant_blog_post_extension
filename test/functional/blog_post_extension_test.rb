require File.dirname(__FILE__) + '/../test_helper'

class BlogPostExtensionTest < Test::Unit::TestCase
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'news_post'), BlogPostExtension.root
    assert_equal 'Blog Post', BlogPostExtension.extension_name
  end
  
end
