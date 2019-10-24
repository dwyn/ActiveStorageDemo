class FurriesController < ApplicationController
  def index
    @furries = Furry.all
  end

  def show
    # very simple code to grab the proper Post so it can be
    # displayed in the Show view (show.html.erb)
  end

  def new
  end

  def create
  end

  def edit
    @furry = Furry.find(params[:id])
  end

  def update
    @furry = Furry.find(params[:id])
    @furry.update(furry_params)
    if @furry.save
      redirect_to root_path
    else
      render :edit
    end

  end

  def destroy
    # very simple code to find the post we're referring to and
    # destroy it.  Once that's done, redirect us to somewhere fun.
  end

  private
    def furry_params
      params.require(:furry).permit(:name, :specie, :image)
    end
end
