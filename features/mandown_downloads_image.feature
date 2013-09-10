Feature: mandown downloads image
  The program wants to download an image
  Scenario: The program wants to download an image
    When The program downloads an image
    Then The image will be in the current directory
    And It will be an image file
