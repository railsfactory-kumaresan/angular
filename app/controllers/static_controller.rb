class StaticController < ApplicationController
  skip_before_filter :authenticate_user!

  def about
    # @user=current_user # not needed as its not used in views
  end

  def help
    # @user=current_user # not needed as its not used in views
  end
end
