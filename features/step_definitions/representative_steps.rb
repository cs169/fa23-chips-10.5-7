# frozen_string_literal: true

Then /I should see the following table of representatives/ do |expected_table|
  actual_table = page.find('#events').all('tbody tr').map do |row|
    {
      'name'   => row.find('td:nth-child(1)').text,
      'office' => row.find('td:nth-child(2)').text
    }
  end
  expected_hashes = expected_table.hashes
  expect(actual_table).to eq(expected_hashes)
end

Given(/^the representatives for "(.+)" are:$/) do |address, table|
  representatives_data = table.hashes
  offices = representatives_data.map.with_index do |rep, index|
    { 'name' => rep['office'], 'officialIndices' => [index] }
  end
  officials = representatives_data.map do |rep|
    address_parts = rep['address'].split(', ')
    formatted_address = {
      line1: address_parts[0],
      city:  address_parts[1],
      state: address_parts[2],
      zip:   address_parts[3]
    }
    { 'name' => rep['name'], 'party' => rep['party'], 'address' => [formatted_address] }
  end

  stub_request(:get, 'https://civicinfo.googleapis.com/civicinfo/v2/representatives')
    .with(
      query: {
        address: address,
        key:     'AIzaSyCQYdbNQk0FwqcAzYz3YJt5wCOW-9DY5kM'
      }
    )
    .to_return(
      status: 200,
      body:   {
        offices:   offices,
        officials: officials
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end

Then /^I should see the following profile:$/ do |table|
  profile_data = table.rows_hash
  within('.container .row .col-md-8') do
    expect(page).to have_content(profile_data['name'])
    expect(page).to have_content(profile_data['title'])
    expect(page).to have_content("Party: #{profile_data['party']}")
    expect(page).to have_content("Address: #{profile_data['address']}")
  end
end
