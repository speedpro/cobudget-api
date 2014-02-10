Feature: Bucket Allocations
  In order to participate in the collaborative budgeting process
  As a budget participant
  I want to be able to assign my allocation to buckets in a budget

  Background:
    Given a budget Thundera
    Given a bucket Treats in the Thundera budget
    Given a bucket LaserPointers in the Thundera budget
    Given a bucket Tuna in the Thundera budget
    Given a user Liono who has allocation rights of $50 in the Thundera budget
    Given a user Tygra who has allocation rights of $20 in the Thundera budget

  Scenario: Successfully allocate money into a bucket
    When Liono allocates $50 to the Tuna bucket
    Then Liono should have a remaining allocation of $0 in the Thundera budget

  Scenario: Successfully allocate money across multiple buckets
    When Liono allocates $10 to the Treats bucket
    When Liono allocates $20 to the LaserPointers bucket
    Then Liono should have a remaining allocation of $20 in the Thundera budget

  Scenario: Successfully add allocation
    When Liono allocates $10 to the Treats bucket
    When Liono allocates $20 to the LaserPointers bucket
    When Liono allocates $10 to the LaserPointers bucket
    Then Liono should have a remaining allocation of $10 in the Thundera budget
    And Liono should have allocated $30 to the LaserPointers bucket

  Scenario: Successfully remove an allocation
    When Liono allocates $10 to the Treats bucket
    When Liono removes the $10 allocation in the Treats bucket
    Then the Treats bucket should have a balance of $0
    Then Liono should have a remaining allocation of $50 in the Thundera budget

  Scenario: Add up allocations in a budget
    When Tygra allocates $20 to the Tuna bucket
    And Liono allocates $15 to the LaserPointers bucket
    And Liono allocates $25 to the Treats bucket
    Then total used allocations in the Thundera budget should be $60
    And total unallocated in the Thundera budget should be $10
    And total allocation rights in the Thundera budget should be $70

  Scenario: Display allocations in a bucket
    Given Liono has "#00FFDD" as a background colour
    And Tygra has "#FFEEDD" as a background colour
    When Tygra allocates $15 to the Tuna bucket
    And Liono allocates $20 to the Tuna bucket
    And Liono allocates $5 to the Tuna bucket
    Then the allocation total list for the Tuna bucket should include $25 allocation by Liono
    And the allocation total list for the Tuna bucket should include $15 allocation by Tygra

  Scenario: Allocate too much into a bucket
    When Tygra tries to allocate $500 to the Treats bucket but fails
    Then the Treats bucket should have a balance of $0
    Then Tygra should have a remaining allocation of $20 in the Thundera budget

  Scenario: Cannot allocate across buckets in different budgets
    Given a budget MummRasCookieFund
    Given a bucket CookieTime in the MummRasCookieFund budget
    When Liono tries to allocate $20 to the CookieTime bucket but fails
    Then Liono should have a remaining allocation of $0 in the MummRasCookieFund budget
    Then Liono should have a remaining allocation of $50 in the Thundera budget