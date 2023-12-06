@javascript
Feature: display list of counties in a state

  As a voter
  So that I can understand the geographical representation my state
  I want to see the counties in my state

@reset_database
Scenario: see the counties in a state
  Given I am on the Actionmap home page
  When I select state "Delaware"
  And I press "counties_in_delaware"
  Then I should see the following table of counties:
  | name                    | fips_code |
  | Kent County             | 001       |
  | New Castle County       | 003       |
  | Sussex County           | 005       |
