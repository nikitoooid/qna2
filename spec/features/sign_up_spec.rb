require 'rails_helper'

describe 'User can sign up', "
  In order to ask and answer the questions
  As an unauthenticated user
  I'd like to be able to sign up
" do
  let(:user) { create(:user) }

  before { visit new_user_registration_path }

  it 'Unregistred user tries to sign up' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  it 'Registred user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved'
  end
end
