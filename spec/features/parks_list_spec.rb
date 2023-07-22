require 'rails_helper'

feature 'Parks list' do
  scenario 'can be filtered by state' do
    # As a user,
    visit root_path
    # When I select "Tennessee" from the form,
    select 'Tennessee', from: 'state'
    # And click on "Find Parks",
    click_button 'Find Parks'

    # I see the total of parks found,
    expect(page).to have_content "Total Parks: #{10}"
    # And for each park I see:
    first_park = page.first(:css, '.park')
    # - full name of the park
    expect(first_park).to have_content ''
    # - description
    expect(first_park).to have_content ''
    # - direction info
    expect(first_park).to have_content ''
    # - standard hours for operation
    expect(first_park).to have_content ''
  end
end