class ExchangesController < ApplicationController
  before_action :logged_in_user


  def new
    @exchange = Exchange.new(admins: @current_user.id)
  end

  def create
    @exchange = Exchange.new(user_params.merge(admins: [@current_user.id],participants:[@current_user.id]))
    if @exchange.save
      flash[:info] = "Amigo secreto criado."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @exchanges = Exchange.paginate(page: params[:page])
  end

  def show
    @exchange = Exchange.find(params[:id])
  end

  def destroy
    Exchange.find(params[:id]).destroy
    flash[:success] = "Amigo secreto deletado"
    redirect_to exchanges_path
  end

  def invitation
    @exchange = Exchange.find(params[:id])
    unless @exchange.have_user_as?(current_user,'admins')
      flash[:danger] = "Você deve ser um administrador do amigo secreto para convidar outras pessoas!"
      redirect_to exchanges_path
    end
  end

  #Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Por favor, esteja logado para visualizar esse conteúdo"
      redirect_to login_url
    end
  end

  # Confirms a owner.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Por favor, esteja logado para visualizar esse conteúdo"
      redirect_to login_url
    end
  end

  private

  def user_params
    params.require(:exchange).permit(:title,:description)
  end
end