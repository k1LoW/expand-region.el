Feature: Expand Region
  In order to quickly and precisely mark units
  As an Emacs user
  I want to expand to them

  Scenario: Mark entire word with point midword
    Given there is no region selected
    When I insert "This is some text"
    And I go to point "10"
    And I press "C-@"
    Then the region should be "some"

  Scenario: Mark word just behind point
    Given there is no region selected
    When I insert "This is some text"
    And I go to point "13"
    And I press "C-@"
    Then the region should be "some"

  Scenario: Multiple expand-region
    Given there is no region selected
    When I insert "This (is some) text"
    And I go to point "10"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    Then the region should be "(is some)"

  Scenario: Expand from existing selection
    Given there is no region selected
    When I insert "This (is some) text"
    And I go to point "7"
    And I set the mark
    And I go to point "14"
    And I press "C-@"
    Then the region should be "(is some)"

  Scenario: Skip white space forward if spaces on both sides of cursor
    Given there is no region selected
    When I insert "This is    some text"
    And I go to point "10"
    And I press "C-@"
    Then the region should be "some"

  Scenario: Skip white space forward if at beginning of buffer
    Given there is no region selected
    When I insert "   This is some text"
    And I go to beginning of buffer
    And I press "C-@"
    Then the region should be "This"

  Scenario: Skip white space forward if at beginning of line
    Given there is no region selected
    When I insert:
    """
    This is
       some text
    """
    And I go to point "9"
    And I press "C-@"
    Then the region should be "some"

  Scenario: Do not skip white space forward with active region
    Given there is no region selected
    When I insert "This is    some text"
    And I go to point "10"
    And I set the mark
    And I go to point "14"
    And I press "C-@"
    Then the region should be "This is    some text"

  Scenario: Contract region once
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    Then the region should be "(45678)"

  Scenario: Contract region twice
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-S-@"
    Then the region should be "45678"

  Scenario: Contract region all the way back to start
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-S-@"
    And I press "C-S-@"
    Then the region should not be active
    And cursor should be at point "6"

  Scenario: Contract region should only contract previous expansions
    Given there is no region selected
    When I insert "This (is some) text"
    And I go to point "7"
    And I set the mark
    And I go to point "14"
    And I press "C-S-@"
    Then the region should be "is some"

  Scenario: Contract history should be reset when changing buffer
    Given there is no region selected
    When I insert "This is some text"
    And I go to point "10"
    And I press "C-@"
    And I press "C-@"
    And I deactivate the mark
    And I insert "More text"
    And I press "C-S-@"
    Then the region should not be active

  Scenario: Expanding past the entire buffer should not add duplicates to the history
    Given there is no region selected
    When I insert "This is some text"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    Then the region should be "text"

  Scenario: C-g to deactivate mark and move back to start of expansions
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I quit
    Then the region should not be active
    And cursor should be at point "6"

  Scenario: Pop mark twice to get back to start of expansions
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-@"
    And I press "C-@"
    And I pop the mark
    And I pop the mark
    Then cursor should be at point "6"

  Scenario: Pop mark thrice to get back to mark before expansions
    Given there is no region selected
    When I insert "(((45678)))"
    And I go to point "8"
    And I set the mark
    And I deactivate the mark
    And I go to point "6"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-S-@"
    And I press "C-@"
    And I press "C-@"
    And I pop the mark
    And I pop the mark
    And I pop the mark
    Then cursor should be at point "8"

  Scenario: Transient mark mode deactivated
    Given transient mark mode is inactive
    And there is no region selected
    When I insert "This is some text"
    And I go to point "10"
    And I press "C-@"
    Then the region should be "some"

  Scenario: Expand from existing selection without transient-mark-mode
    Given transient mark mode is inactive
    And there is no region selected
    When I insert "This (is some) text"
    And I go to point "7"
    And I set the mark
    And I activate the mark
    And I go to point "14"
    And I press "C-@"
    Then the region should be "(is some)"

  Scenario: Do not skip white space forward with active region without tmm
    Given transient mark mode is inactive
    And there is no region selected
    When I insert "This is    some text"
    And I go to point "10"
    And I set the mark
    And I activate the mark
    And I go to point "14"
    And I press "C-@"
    Then the region should be "This is    some text"

  Scenario: Set-mark-default-inactive
    Given mark is inactive by default
    And there is no region selected
    When I insert "This (is some) text"
    And I go to point "6"
    And I press "C-@"
    Then the region should be "(is some)"

  Scenario: Use er/mark-word, Because region length is most shortest
    Given there is no region selected
    Given er/try-expand-list by default
    When I add er/mark-whole-line to er/try-expand-list
    When I insert:
    """
    This (is (some)
    text) and more
    """
    And I go to point "13"
    And I press "C-@"
    Then the region should be "some"
    Then the region length "4"

  Scenario: Use er/mark-outside-pairs, Because region length is 2nd most shortest
    Given there is no region selected
    Given er/try-expand-list by default
    When I add er/mark-whole-line to er/try-expand-list
    When I insert:
    """
    This (is (some)
    text) and more
    """
    And I go to point "13"
    And I press "C-@"
    And I press "C-@"
    Then the region should be "(some)"
    Then the region length "6"

  Scenario: Use er/mark-inside-pairs, Because region length is 3rd most shortest
    Given there is no region selected
    Given er/try-expand-list by default
    When I add er/mark-whole-line to er/try-expand-list
    When I insert:
    """
    This (is (some)
    text) and more
    """
    And I go to point "13"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    Then the region length "14"

  Scenario: Use er/mark-whole-line, Because region length is 4th most shortest
    Given there is no region selected
    Given er/try-expand-list by default
    When I add er/mark-whole-line to er/try-expand-list
    When I insert:
    """
    This (is (some)
    text) and more
    """
    And I go to point "13"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    And I press "C-@"
    Then the region length "15"
