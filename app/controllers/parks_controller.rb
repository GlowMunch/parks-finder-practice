class ParksController < ApplicationController
  def index
    conn = Faraday.new(
      url: 'https://developer.nps.gov',
      headers: {
        'Content-Type' => 'application/json',
        'X-Api-Key' => Rails.application.credentials.nps_api_key
      }
    )

    response = conn.get('/api/v1/parks') do |req|
      req.params['stateCode'] = 'TN'
    end

    @parks_data = JSON.parse(response.body)
  end
end