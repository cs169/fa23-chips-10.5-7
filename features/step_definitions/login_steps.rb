Given("I am on the login page") do
  visit https://fa23-07-a15c6dc19648.herokuapp.com/login
end

When("I click on the {string} login button") do |provider|
  click_on "#{provider} login"
end

Then("I should be redirected to the {string} authentication page") do |provider|
  # Add appropriate steps for asserting the redirection to the authentication page
  # You might want to use a gem like Capybara to interact with the page
end

And("I should be logged in with the {string} account") do |provider|
  # Add appropriate steps for asserting the successful login
  # Verify that the user is redirected to the expected page after successful login
end

Given("I am logged in") do
  # Implement the necessary steps to log in a user for testing the logout scenario
  # You might want to use a gem like Capybara to interact with the page
end

When("I click on the {string} button") do |button|
  click_on button
end

Then("I should be redirected to the home page") do
  expect(page).to have_current_path(https://fa23-07-a15c6dc19648.herokuapp.com/)
end

And("I should see a notice that I have successfully logged out") do
  expect(page).to have_content("You have successfully logged out.")
end