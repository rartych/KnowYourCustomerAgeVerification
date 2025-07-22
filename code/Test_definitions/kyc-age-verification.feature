Feature: CAMARA KYC Age Verification API, v0.2.0-rc.1 - Operation verifyAge
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  #
  # Testing assets:
  # * A mobile line identified by its phone number "phoneNumber"
  #
  # References to OAS spec schemas refer to schemas specifies in kyc-age-verification.yaml, version v0.2.0-rc.1

  Background: Common verifyAge setup
    Given an environment at "apiRoot"
    And the resource "/kyc-age-verification/v0.2rc1/verify"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema

  # Happy path scenarios

  @verifyAge_1_verify_age_true
  Scenario Outline: Validate successful response when ageCheck is true
    Given a valid testing phone number supported by the service, identified by the access token or provided in the request body
    And the request body property "$.ageThreshold" is set to a valid value compliant with the OAS schema at "#/components/schemas/AgeThreshold"
    And the age information associated with the mobile subscription is equal or greater that the age threshold provided
    And the request body optionally contains the property "<request_body_property>" with a value compliant with OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyResponseBody"
    And the response property "$.ageCheck" is "true"
    And if the response contains property "$.verifiedStatus", the value is one of [true, false]
    And if the response contains property "$.identityMatchScore", the value is compliant with OAS schema at "#/components/schemas/IdentityMatchScore"

    Examples:
      | request_body_property | oas_spec_schema                       |
      | $.idDocument          | /components/schemas/IdDocument        |
      | $.name                | /components/schemas/Name              |
      | $.givenName           | /components/schemas/GivenName         |
      | $.familyName          | /components/schemas/FamilyName        |
      | $.middleNames         | /components/schemas/MiddleNames       |
      | $.familyNameAtBirth   | /components/schemas/FamilyNameAtBirth |
      | $.birthdate           | /components/schemas/Birthdate         |
      | $.email               | /components/schemas/Email             |


  @verifyAge_2_verify_age_false
  Scenario Outline: Validate successful response when ageCheck is false
    Given a valid testing phone number supported by the service, identified by the access token or provided in the request body
    And the request body property "$.ageThreshold" is set to a valid value compliant with the OAS schema at "#/components/schemas/AgeThreshold"
    And the age information associated with the mobile subscription is lower that the age threshold provided
    And the request body optionally contains the property "<request_body_property>" with a value compliant with OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/VerifyResponseBody"
    And the response property "$.ageCheck" is "false"
    And if the response contains property "$.verifiedStatus", the value is one of [true, false]
    And if the response contains property "$.identityMatchScore", the value is compliant with OAS schema at "#/components/schemas/IdentityMatchScore"

    Examples:
      | request_body_property | oas_spec_schema                       |
      | $.idDocument          | /components/schemas/IdDocument        |
      | $.name                | /components/schemas/Name              |
      | $.givenName           | /components/schemas/GivenName         |
      | $.familyName          | /components/schemas/FamilyName        |
      | $.middleNames         | /components/schemas/MiddleNames       |
      | $.familyNameAtBirth   | /components/schemas/FamilyNameAtBirth |
      | $.birthdate           | /components/schemas/Birthdate         |
      | $.email               | /components/schemas/Email             |

  @verifyAge_3_verify_age_not_available
  Scenario Outline: Validate successful response when ageCheck is not available
    Given a valid testing phone number supported by the service, identified by the access token or provided in the request body
    And the request body property "$.ageThreshold" is set to a valid value compliant with the OAS schema at "#/components/schemas/AgeThreshold"
    And the API Provider cannot verify the age information
    And the request body optionally contains the property "<request_body_property>" with a value compliant with OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "*

