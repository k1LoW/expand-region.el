Feature: Mark pairs
  In order to quickly and precisely mark pairs
  As an Emacs user
  I want to expand to them

  Scenario: Mark pair when looking at it
    Given there is no region selected
    When I insert "... (some parens) ..."
    And I go to point "5"
    And I expand the region
    Then the region should be "(some parens)"

  Scenario: Mark pair when looking behind at it
    Given there is no region selected
    When I insert "... (some parens) ..."
    And I go to point "18"
    And I expand the region
    Then the region should be "(some parens)"

  Scenario: Mark inside pairs
    Given there is no region selected
    When I insert "... (some parens) ..."
    And I go to point "10"
    And I expand the region 2 times
    Then the region should be "some parens"

  Scenario: Mark child in nested pairs
    Given there is no region selected
    When I insert "... (some (more parens)) ..."
    And I go to point "11"
    And I expand the region
    Then the region should be "(more parens)"

  Scenario: Mark inner parent in nested pairs
    Given there is no region selected
    When I insert "... (some (more parens)) ..."
    And I go to point "11"
    And I expand the region 2 times
    Then the region should be "some (more parens)"

  Scenario: Mark outer parent in nested pairs
    Given there is no region selected
    When I insert "... (some (more parens)) ..."
    And I go to point "11"
    And I expand the region 3 times
    Then the region should be "(some (more parens))"

  Scenario: Mark outer parent in nested pairs (leftie)
    Given there is no region selected
    When I insert "... ((some more) parens) ..."
    And I go to point "6"
    And I expand the region 3 times
    Then the region should be "((some more) parens)"
