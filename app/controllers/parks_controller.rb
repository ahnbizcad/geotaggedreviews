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

      @rating_5_star = @reviews.with_stars(5).size
      @rating_4_star = @reviews.with_stars(4).size
      @rating_3_star = @reviews.with_stars(3).size
      @rating_2_star = @reviews.with_stars(2).size
      @rating_1_star = @reviews.with_stars(1).size
    else      
      @avg_rating = 0
      @rating_5_star = 0
      @rating_4_star = 0
      @rating_3_star = 0
      @rating_2_star = 0
      @rating_1_star = 0
    end
    @percent_5_star = 100*@rating_5_star/@reviews_size
    @percent_4_star = 100*@rating_4_star/@reviews_size
    @percent_3_star = 100*@rating_3_star/@reviews_size
    @percent_2_star = 100*@rating_2_star/@reviews_size
    @percent_1_star = 100*@rating_1_star/@reviews_size
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
