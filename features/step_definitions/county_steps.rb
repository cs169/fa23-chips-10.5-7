# frozen_string_literal: true

When /^(?:|I )select county "([^"]*)"$/ do |county_name|
  find("[data-county-name='#{county_name}']").click
end

Then /I should see the following table of counties/ do |expected_table|
  sleep 0.1
  expected_data = expected_table.hashes
  table = find('#actionmap-state-counties-table')
  table_data = table.all('tbody tr').map do |row|
    {
      'name'      => row.find('td:nth-child(2)').text,
      'fips_code' => row.find('td:nth-child(3)').text
    }
  end
  expect(table_data).to eq(expected_data)
end
