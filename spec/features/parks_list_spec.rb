require 'rails_helper'

feature 'Parks list' do
  scenario 'can be filtered by state' do
    parks_json = file_fixture('parks.json').read
    parks_response = JSON.parse(parks_json)

    stub_request(:get, "https://developer.nps.gov/api/v1/parks?stateCode=TN")
    .with(headers: {'X-Api-Key' => Rails.application.credentials.nps_api_key})
    .to_return(body: parks_json)

    # As a user,
    visit root_path
    # When I select "Tennessee" from the form,
    select 'Tennessee', from: 'state'
    # And click on "Find Parks",
    click_button 'Find Parks'

    # I see the total of parks found,
    expect(page).to have_content "Total Parks: #{parks_response['total']}"
    # And for each park I see:
    first_park = page.first(:css, '.park')
    # - full name of the park
    expect(first_park).to have_content parks_response['data'][0]['fullName']
    # - description
    expect(first_park).to have_content parks_response['data'][0]['description']
    # - direction info
    expect(first_park).to have_content parks_response['data'][0]['directionsInfo']
    # - standard hours for operation
    expect(first_park).to have_content parks_response['data'][0]['operatingHours'][0]['standardHours']
  end
end