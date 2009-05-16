class Admin::ArticlePreviewController < ApplicationController
  before_filter :load_article
  
  def create
    if @article.valid?
      @page = @article.to_page
      set_dates
      if @page.valid? || (@page.errors.size == 1 && @page.errors.on(:slug) =~ /slug already in use/)
        begin
          Page.transaction do
            PagePart.transaction do
              @page.process(request, response)
              @performed_render = true
              raise "Render performed"
            end
          end
        rescue Exception => ex
          unless @performed_render
            render :update do |page|
              page.alert("Could not preview the article! #{ex.message}")
            end
          end
        end
      else
        render :update do |page|
          page.alert("Could not preview the article!\n\n\t-#{@page.errors.full_messages.join("\n\t-")}")
        end
      end
    else
      render :update do |page|
        page.alert("Could not preview the article!\n\n\t-#{@article.errors.full_messages.join("\n\t-")}")
      end
    end
  end
  
  private
    def load_article
      @article = Article.new(params[:article])
    end
    
    def set_dates
      if params[:article_preview] && params[:article_preview][:page_id]
        if db_page = Page.find_by_id(params[:article_preview][:page_id])
          @page.created_at = db_page.created_at
          @page.published_at = db_page.published_at
        end
      end
      @page.created_at = Time.now if @page.created_at.blank?
      @page.published_at = Time.now if @page.published_at.blank?
      @page.updated_at = Time.now
    end
  
end
