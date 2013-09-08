Feature: mandown downloads page
  The program wants to download a page
  Scenario: The program wants to download a page
    When The program downloads a page
    Then The page will be saved in the current directory
