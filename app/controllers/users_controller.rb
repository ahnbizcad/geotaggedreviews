class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  before_action :set_user,            only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def edit

  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'user was successfully updated.' }
        format.json { render :index, status: :ok, location: @users }
      else
        format.html { render :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :username, :admin, :created_at, :last_sign_in_at)
    end

end