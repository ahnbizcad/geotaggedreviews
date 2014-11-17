class ParksController < ApplicationController
  before_action :authenticate_user!,  except: [:search, :index, :show]
  before_action :check_admin,         only: [:destroy]

  before_action :set_park,            only: [:show, :edit, :update, :destroy]

  def search
    if params[:search].present?
      @parks = Park.search(params[:search]) # .search method provided by searchkick
    else
      @parks = Park.all
    end
  end

  def index
    @parks = Park.all.includes(:reviews)
    #paginate and limit parks so that it doesn't include all reviews.
  end

  def show
    @reviews = @park.the_reviews

    @average_rating = @park.average_rating
    @reviews_count = @park.reviews_count
    # Use hashes instead.
    @ratings_histogram = @park.ratings_histogram
    @percentages = @park.percentages
  end

  def new
    @park = Park.new
    #so slow. why?
  end

  def edit
  end

  def create
    @park = Park.new(park_params)

    respond_to do |format|
      if @park.save
        format.html { redirect_to @park, notice: 'Park was successfully created.' }
        format.json { render :show, status: :created, location: @park }
      else
        format.html { render :new }
        format.json { render json: @park.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @park.update(park_params)
        format.html { redirect_to @park, notice: 'Park was successfully updated.' }
        format.json { render :show, status: :ok, location: @park }
      else
        format.html { render :edit }
        format.json { render json: @park.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @park.destroy
    respond_to do |format|
      format.html { redirect_to parks_url, notice: 'Park was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#

  private
    def set_park
      @park = Park.find(params[:id])
    end

    def park_params
      params.require(:park).permit(:address, :image_url)
    end

end
