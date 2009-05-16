class Article < ActiveRecord::Base
  has_no_table

  PARTS = [[ :summary, { 
               :type => :text,
               :optional => true } ],
           [ :body, { 
               :type => :text,
               :filter => 'Markdown' } ]]

  column :parent_id, :integer
  column :title, :string
  column :status, :string

  PARTS.each do |name, part|
    column(name, part[:type])
  end

  validates_presence_of :parent_id, :title

  PARTS.each do |name, part|
    validates_presence_of(name) unless part[:optional]
  end

  def self.create_from_page(page)
    article = Article.new(:title => page.title,
                          :parent_id => page.parent_id,                       
                          :status => page.status.name)
    PARTS.each do |name, part|
      article.send("#{name}=", page.parts.find_by_name(name.to_s).try(:content))
    end

    article
  end

  def initialize(params = nil)
    unless params.nil?
      img = params.delete(:spotlight_image)
      @spotlight_image = Asset.create(:title => 'spotlight_image', :asset => img) if img
    end
    
    super
  end

  def slug
    title.slugize
  end

  def breadcrumb
    title
  end

  def to_page
    page = Page.new(:title => title, 
                    :slug => slug,
                    :breadcrumb => breadcrumb,
                    :parent_id => parent_id,
                    :status => Status[status],
                    :layout => Layout.find_by_name('Article'))

    PARTS.each do |name, part|
      page.parts.build(:name => name.to_s, 
                       :content => self.send(name), 
                       :filter_id => part[:filter] )
    end

    page
  end

  def update_page(page)
    begin
      Page.transaction do
        page.update_attributes!(:title => title,
                                :parent_id => parent_id,
                                :status => Status[status])
                                
        PARTS.each do |name, part|
          part = page.parts.find_by_name(name.to_s)
          part.content = self.send(name)
          part.save!
        end
      end

      return true
    rescue Exception => ex
      return false
    end
  end

  def create_page
    if self.valid?
      page = to_page
      if page.save then page else nil end
    end
  end
end
