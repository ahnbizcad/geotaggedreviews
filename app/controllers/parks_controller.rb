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
    @parks = Park.all
  end

  def show
    @reviews = Review.of_park(@park.id).includes(:user).by_newest

    @reviews_size = @reviews.size

    if @reviews.present?
      @avg_rating = @reviews.average(:rating).round(2)

      # Refactor into model instead.
      # Use hashes instead.
      @ratings_count = []
      @percentages = []
      5.downto(1).each do |val|
        @ratings_count << @reviews.with_stars(val).size
        @percentages << (100 * @reviews.with_stars(val).size) / (@reviews_size)
      end
    else      
      @avg_rating = 0

      @ratings_count = Array.new(5, 0)

      @percentages = Array.new(5, 0)
    end
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

    def check_admin
      unless current_user.admin?
        redirect_to (request.referrer || root_url), notice: "Sorry, admins only."
      end
    end

end
