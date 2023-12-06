@javascript
Feature: display list of representatives for an address

  As a voter
  So that I can connect with my representatives
  I want to see the list of representatives for my county

Background:
  Given the representatives for "Alameda County, California" are:
  | name                | office                        | party         | address                                   |
  | Hagrid              | Keeper of Keys and Grounds    | Gryffindor    | 123 Hogwarts Lane, Hogsmeade, HM, 12345   |
  | Albus Dumbledore    | Headmaster                    | Gryffindor    | 2299 Piedmont Ave, Berkeley, CA, 94720    |

Scenario: see the representatives by searching an address
  Given I am on the Actionmap representatives page
  When I fill in "address" with "Alameda County, California"
  And I press "search_representatives"
  Then I should see the following table of representatives:
  | name                | office                        |
  | Hagrid              | Keeper of Keys and Grounds    |
  | Albus Dumbledore    | Headmaster                    |

@reset_database
Scenario: see the representatives by clicking a county on the map
  Given I am on the Actionmap home page
  When I select state "California"
  And I select county "Alameda County"
  Then I should see the following table of representatives:
  | name                | office                        |
  | Hagrid              | Keeper of Keys and Grounds    |
  | Albus Dumbledore    | Headmaster                    |
