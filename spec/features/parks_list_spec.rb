require 'rails_helper'

feature 'Parks list' do
  scenario 'can be filtered by state' do
    # This is less than ideal.
    # Feature testing this endpoint and having to stub the api call means that every time the nps api changes
    # You will need to adjust this test which is hard and annoying
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
    # Kinda sucks that we are dealing with multiple layers of the response (top level for "total" and then the nested objects inside "data")
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
    # This is a HUGE code smell. When you need to destructure through multiple layers to get an expected value it is not good
    expect(first_park).to have_content parks_response['data'][0]['operatingHours'][0]['standardHours']
  end
end