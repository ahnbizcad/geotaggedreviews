class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_park

  before_action :authenticate_user! # calling authenticate_user before check_user checks unlogged before user
  before_action :check_user, only: [:edit, :destroy] #why is :update not necessary? can't issue put/patch unless from edit page's form?

  before_action :check_review, only: [:new, :edit]

  def new
    @review = Review.new
    if @existing_review
      redirect_to edit_park_review_path(@park, @existing_review)
    end

  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.park_id = @park.id
    @review.user_id = current_user.id

    respond_to do |format|
      if @review.save
        format.html { redirect_to @park, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @park, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to @review.park, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

#

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(:rating, :comment) #park_id and user_id in params, or just set in controller (latter seems bad)?   
    end
    
    def set_park
      @park = Park.find(params[:park_id]) #get it through review object? or from params, and change park_id as explicit param?
      #:park_id works because of nesting reviews under parks as a collection in the routes
    end

    def check_user # not compliant with SingleResponsibilityPrinciple. What's a better design pattern?
      unless @review.user == current_user || (current_user.admin? if user_signed_in?) # How to check admin before redirecting, while keeping each aspect separate?
        redirect_to request.referrer || root_url, notice: "Sorry, you can't go here."
      end
    end

    def check_review      
      @existing_review = Review.of_park(@park.id).by_user(current_user.id).first if user_signed_in?
    end

end
