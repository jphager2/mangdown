Feature: mandown downloads chapter
  The program wants to download a chapter
  Scenario: The program wants to download a chapter
    When The program downloads a chapter
    Then A directory will be created in the current directory
    And It will contain the images (Page) in the chapter
