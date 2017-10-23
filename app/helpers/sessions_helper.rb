module SessionsHelper
  private

  # Is the user signed in?
  # @return [Boolean]
  def user_signed_in?
    session[:uid].present?
  end

  # Set the @current_user or redirect to public page
  def authenticate_user!
    # Redirect to page that has the login here
    if user_signed_in?
      current_user
      puts "@current_user == " + @current_user.pretty_print_inspect
    else
      redirect_to login_path
    end
  end

  # What's the current_user?
  # @return [Hash]
  def current_user
    @current_user = User.find_by uid: session[:uid]
  end

  # @return the path to the login page
  def login_path
    root_path
  end
end