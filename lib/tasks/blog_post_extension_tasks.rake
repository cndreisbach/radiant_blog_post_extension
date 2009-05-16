namespace :radiant do
  namespace :extensions do
    namespace :blog_post do    
      desc "Copies public assets of the Blog Post to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from BlogPostExtension"
        Dir[BlogPostExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(BlogPostExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
