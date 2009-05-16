class Admin::ArticlesController < ApplicationController
  before_filter :load_blogs
  before_filter :load_article, :only => [:new, :create, :update]
  before_filter :load_page, :only => [:edit, :update]
  
  def index
    render
  end

  def edit
    @article = Article.create_from_page(@page)
  end

  def new
    render
  end

  def create
    if page = @article.create_page
      announce_success("article", "created")

      if params['save_and_continue']
        redirect_to article_url(page)
      else
        redirect_to articles_url
      end
    else
      announce_errors
      render :action => 'new'
    end
  end

  def update
    if @article.update_page(@page)
      announce_success("article", "updated")

      if params['save_and_continue']
        redirect_to article_url(page)
      else
        redirect_to articles_url
      end
    else
      announce_errors
      render :action => 'show'
    end
  end

  private

  def load_blogs
    @blogs = ArchivePage.all(:order => 'title ASC')
  end

  def load_article
    @article = Article.new(params[:article])
  end

  def load_page
    @page = Page.find(params[:id])
  end
  
  def announce_success(noun, verbed)
    flash[:notice] = "Your #{noun} was #{verbed} successfully."
  end
  
  def announce_errors
    msg = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
    flash.now[:error] = msg
  end
end
