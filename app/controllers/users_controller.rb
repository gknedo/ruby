class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @current_user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Verifique seu email para ativar sua conta."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Perfil atualizado"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuário deletado"
    redirect_to users_path
  end

  #Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Por favor, esteja logado para visualizar esse conteúdo"
      redirect_to login_path
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 :address_street,:address_number,:address_aditional,:address_zip,
                                 :address_city,:address_state,:address_country,:about)
  end
end