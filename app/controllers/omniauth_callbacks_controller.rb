class OmniauthCallbacksController < ApplicationController
  skip_before_filter :authenticate_user!

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.from_omniauth( env["omniauth.auth"], current_user )
        if @user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "#{provider}".capitalize
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:facebook, :twitter].each do |provider|
    provides_callback_for provider
  end

end
