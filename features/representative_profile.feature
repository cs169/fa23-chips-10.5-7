@javascript
Feature: display the profile of a representative

  As a voter
  So that I know a representative's party affiliation
  I want to see the profile of the representative

Scenario: see the profile of a representative
  Given I am on the Actionmap representatives page
  And the representatives for "Alameda County, California" are:
    | name              | office                     | party      | address                                  |
    | Hagrid            | Keeper of Keys and Grounds | Gryffindor | 123 Hogwarts Lane, Hogsmeade, HM, 12345  |
    | Albus Dumbledore  | Headmaster                 | Gryffindor | 2299 Piedmont Ave, Berkeley, CA, 94720   |
  And I fill in "address" with "Alameda County, California"
  And I press "search_representatives"
  When I follow "albusdumbledore_profile"
  Then I should see the following profile:
    | name         | Albus Dumbledore                       |
    | title        | Headmaster                             |
    | party        | Gryffindor                             |
    | address      | 2299 Piedmont Ave, Berkeley, CA, 94720 |
