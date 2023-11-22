Feature: User Authentication

  Scenario: Logging in with Google
    Given I am on the login page
    When I click on the "Google" login button
    Then I should be redirected to the Google authentication page
    And I should be logged in with the Google account

  Scenario: Logging in with GitHub
    Given I am on the login page
    When I click on the "GitHub" login button
    Then I should be redirected to the GitHub authentication page
    And I should be logged in with the GitHub account

  Scenario: Logging out
    Given I am logged in
    When I click on the "Logout" button
    Then I should be redirected to the home page
    And I should see a notice that I have successfully logged out