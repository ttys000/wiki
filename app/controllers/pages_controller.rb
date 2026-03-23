class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  before_action :set_page, only: %i[show edit update]

  def index
    @pages = Page.order(:title)
  end

  def show
    if @page.nil?
      if authenticated?
        redirect_to new_page_path(title: params[:slug].tr("-", " "))
      else
        redirect_to root_path, alert: "页面不存在。"
      end
    end
  end

  def new
    @page = Page.new(title: params[:title])
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to page_path(@page), notice: "页面已创建。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to root_path, alert: "页面不存在。" if @page.nil?
  end

  def update
    if @page.update(page_params)
      redirect_to page_path(@page), notice: "页面已更新。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:slug])
  end

  def page_params
    params.require(:page).permit(:title, :body)
  end
end
