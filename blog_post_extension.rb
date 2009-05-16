require File.join(File.dirname(__FILE__), 'lib/extensions')

class BlogPostExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/blog_post"
  
  define_routes do |map|
    map.resources :articles, :path_prefix => 'admin', :controller => 'admin/articles'
    map.resource :article_preview, :path_prefix => 'admin', :controller => 'admin/article_preview'
  end
  
  def activate
    admin.tabs.add "Articles", "/admin/articles", :after => "Layouts", :visibility => [:admin, :developer]
  end
  
  def deactivate
    admin.tabs.remove "Articles"
  end
end
