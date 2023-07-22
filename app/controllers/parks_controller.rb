class ParksController < ApplicationController
  # We are going to fix this in 3 phases
  # 1. Service layer for api calls
  # 2. PORO for data presentation
  # 3. Facade to tie it all together

  def index
    # A lot of unencapsulated code, which means you have a much harder setup to test this behavior
    conn = Faraday.new(
      url: 'https://developer.nps.gov',
      headers: {
        'Content-Type' => 'application/json',
        'X-Api-Key' => Rails.application.credentials.nps_api_key
      }
    )

    # you will have to stub this call for any tests that hit this controller
    response = conn.get('/api/v1/parks') do |req|
      req.params['stateCode'] = 'TN'
    end

    # The presentation of data is determined by the third party api directly
    @parks_data = JSON.parse(response.body)
  end
end