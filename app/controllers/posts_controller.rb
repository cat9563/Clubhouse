class PostsController < ApplicationController
before_action :logged_in_user, only: [:new, :create, :show]
def index
  @posts = Post.all
end

def new
  @post = Post.new
end

def create
  @post = Post.new(post_params)
  @post.user_id = current_user.id
  @post.save

  redirect_to posts_path
end

def show
  @post = Post.find(params[:id])
end
private

# Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end

  #Before filters

  #Confirms a logged_in_user.
  def logged_in_user
    unless logged_in?
      flash[:danger]="please log in"
      redirect_to login_url
    end
  end

  #Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  #Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
