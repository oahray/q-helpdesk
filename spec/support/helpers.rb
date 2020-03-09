module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit signup_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign up'
    end

    def sign_in_with(email, password)
      visit login_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Login'
    end

    def sign_in_as(user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
  end
end