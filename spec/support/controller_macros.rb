# frozen_string_literal: true

module ControllerMacros
  def sign_in_user
    before do
      @current_user = create :user
      @request.session['bottles_in_the_sea_token'] = Auth::GenerateTokenService.call(user: @current_user).result
    end
  end

  def sign_in_unconfirmed_user
    before do
      @current_user = create :user, :not_confirmed
      @request.session['bottles_in_the_sea_token'] = Auth::GenerateTokenService.call(user: @current_user).result
    end
  end
end
