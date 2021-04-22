# The Swedish OpenID Connect Profile

### Version: 1.0 - draft 01 - 2021-04-21

## Abstract

This specification defines a profile for OpenID Connect for use within the Swedish public and private sector. It profiles the OpenID Connect protocol to get a baseline security and to facilitate interoperability between relying parties and OpenID providers.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Conformance](#conformance)    

2. [**Authentication Requests**](#authentication-requests)

    2.1. [Authentication Request Parameters](#authentication-request-parameters)
    
    2.2. [Processing of Authentication Requests](#processing-of-authentication-requests)

    2.1.1. [The scope Parameter](#the-scope-parameter)
        
    2.1.2. [The state Parameter](#the-state-parameter)
    
    2.1.3. [The redirect_uri Parameter](#the-redirect-uri-parameter)
    
    2.1.4. [The prompt Parameter](#the-prompt-parameter)

    2.1.5. [The login_hint Parameter](#the-login-hint-parameter)
    
    2.1.6. [The claims Parameter](#the-claims-parameter)
    
    2.1.7. [The acr_values and vtr Parameters](#the-acr-values-and-vtr-parameters)
    
    2.1.8. [Request Objects (request and request_uri parameters)](#request-objects-request-and-request-uri-parameters)
    
	2.1.9. [PKCE Parameters](#pkce-parameters)
	
3. [**Token Endpoint Requests and ID Token Issuance**](#token-endpoint-requests-and-id-token-issuance)
    
    3.1. [Token Requests](#token-requests)
    
    3.1.1. [Client Authentication](#client-authentication)
    
    3.2. [Token Responses and Validation](#token-responses-and-validation)
    
    3.2.1. [ID Token Contents](#id-token-contents)
    
    3.2.2. [ID Token Validation](#id-token-validation)
    
4. [**Claims and Scopes**](#claims-and-scopes)

    4.1. [Mandatory Identity Claims](#mandatory-identity-claims)
    
    4.2. [Mandatory Identity Scopes](#mandatory-identity-scopes)
    
    4.3. [UserInfo Endpoint](#userinfo-endpoint)
    
    4.4. [Claims Release Requirements](#claims-release-requirements)

5. [**Discovery**](#discovery)

    5.1. [Discovery Requirements for a Relying Party](#discovery-requirements-for-a-relying-party)

    5.2. [Discovery Requirements for an OpenID Provider](#discovery-requirements-for-an-openid-provider)

6. [**Client Registration**](#client-registration)

7. [**Security Requirements**](#security-requirements)

    7.1. [Cryptographic Algorithms](#cryptographic-algorithms)

8. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

This specification defines a profile for OpenID Connect for use within the Swedish public and private sector. It profiles the OpenID Connect protocol to get a baseline security and to facilitate interoperability between relying parties and OpenID providers.

The profile is loosely based on the International Government Assurance Profile for OpenID Connect draft, \[[OpenID.iGov](#openid-igov)\], but since work and progress within the OpenID foundation iGov working group seems to have stopped, the Swedish OpenID Connect working group has decided to produce a stand-alone profile for OpenID Connect.

> Should the work within the OpenID foundation iGov working group be resumed, the Swedish profile will adapt to this work. 


<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="conformance"></a>
### 1.2. Conformance

This profile defines requirements for OpenID Connect Relying Parties (clients) and OpenID Connect Providers (identity providers). Furthermore, it defines the interaction between a Relying Party and an OpenID Provider.

When a component compliant with this profile is interacting with other components compliant with this profile, all components MUST fully conform to the features and requirements of this specification. Any interaction with components that are not compliant with this profile is out of scope for this specification.

<a name="authentication-requests"></a>
## 2. Authentication Requests

An OpenID Connect authentication request is a request sent to the Authorization endpoint of an OpenID Provider. These requests MUST be sent using the authorization code flow.

This chapter defines requirements for Relying Parties issuing requests and OpenID Providers processing requests that MUST be followed in order to be compliant with this profile.

<a name="authentication-request-parameters"></a>
### 2.1. Authentication Request Parameters

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] defines a set of request parameters for OpenID Connect.  

Below follows a table with request parameters that are mandatory according to this profile along with selected optional parameters for which this profile extends the requirements or descriptions given in \[[OpenID.Core](#openid-core)\].

> In the cases where a parameter is optional for a Relying Party but mandatory for an OpenID Provider this is explicitly indicated.


| Parameter | Description | Mandatory/Optional |
| :--- | :--- | :--- |
| `client_id` | The client identifier valid at the OpenID Provider/Authorization Server. | Mandatory |
| `response_type` | The response type. MUST be set to `code`. | Mandatory |
| `scope` | Indicates the scopes requested. See [2.2.1](#the-scope-parameter) below. | Mandatory |
| `state` | Random string generated by the Relying Party. The state is used to protect against CSRF attacks. This value is returned to the Relying Party in the authentication response. See [2.2.2](#the-state-parameter) below. | Mandatory |
| `redirect_uri` | The endpoint where the Relying Party will receive the authentication response. See [2.1.3](#the-redirect-uri-parameter) below. | Mandatory |
| `nonce` | String value used to associate a client session with an ID Token, and to mitigate replay attacks. The value is a (unguessable) random string generated by the Relying Party. The nonce value is returned to the Relying Party in the ID Token. | Mandatory |
| `prompt` | Space delimited, case sensitive list of string values that specifies whether the OpenID Provider prompts the end-user for re-authentication and consent. See [2.1.4](#the-prompt-parameter) below.| Optional for RP<br />Mandatory for OP |
| `login_hint` | Hint to the OpenID Provider about an identifier of the end-user. [2.1.5](#the-login-hint-parameter) below. | Optional |
| `claims` | Parameter for requesting individual claims and specifying parameters that apply to the requested claims. See [2.1.6](the-claims-parameter) below. | Optional for RP<br />Mandatory for OP |
| `acr_values` | Requested Authentication Context Class Reference values. See [2.1.7](#the-acr-values-and-vtr-parameters) below. | Optional for RP<br />Mandatory for OP |
| `vtr` | Requested Vectors-of-trust. See [2.1.7](#the-acr-values-and-vtr-parameters) below. | Optional |
| `request` | Request Object JWT. See [2.1.8](#request-objects-request-and-request-uri-parameters). | Optional for RP<br />Mandatory for OP |
| `request_uri` | Request Object JWT passed by reference. See [2.1.8](#request-objects-request-and-request-uri-parameters). | Optional |
| `code_challenge`, `code_challenge_method` | Proof Key for Code Exchange (PKCE). See [2.1.9](#pkce-parameters) below. | Optional |


<a name="the-scope-parameter"></a>
#### 2.1.1. The scope Parameter

The `scope` parameter value MUST contain `openid` and MAY contain additional scopes controlling required claims.

See \[[AttrSpec](#attr-spec)\] for all the defined scopes for this profile, and section [4, Claims and Scopes](#claims-and-scopes), for the scopes that are mandatory to support.

<a name="the-state-parameter"></a>
#### 2.1.2. The state Parameter

Relying Parties MUST use an unguessable random value for the `state` parameter, where the value has at least 128 bits of entropy. 

Relying Parties MUST validate the value of the `state` parameter upon return to the redirect URI and MUST ensure that the value is tied to the current session of the user.

An OpenID Provider MUST include the value of the `state` parameter in the authentication response.

<a name="the-redirect-uri-parameter"></a>
#### 2.1.3. The redirect_uri Parameter

An OpenID Relying Party MUST include the complete redirect URI as a `redirect_uri` parameter value.

In order to prevent open redirection and other injection attacks, the OpenID Provider MUST match the entire URI using a direct string comparison against registered values and MUST reject requests with an invalid or missing redirect URI.

<a name="the-prompt-parameter"></a>
#### 2.1.4. The prompt Parameter

A Relying Party MAY use the `prompt` parameter to control, or prevent, Single Sign On.

By setting the `prompt` parameter to `none` it instructs the OpenID Provider that no display of any authentication or consent views is allowed, and that an error should be returned if the user is not already authenticated at the OpenID Provider. This corresponds to the SAML authentication request attribute `IsPassive=true`.

By setting the `prompt` parameter to `login` the Relying Party instructs the OpenID Provider that the user MUST authenticate, and that it MUST NOT use a previous authentication session for the end-user. This corresponds to the SAML authentication request attribute `ForceAuthn=true`. 

An OpenID Provider MUST support the `prompt` parameter according to the requirements in section 3.1.2.1 of \[[OpenID.Core](#openid-core)\], with the following extension: If the value of the `prompt` parameter contains the "login" string value the OpenID Provider MUST prompt the end-user for (re-)authentication.

<a name="the-login-hint-parameter"></a>
#### 2.1.5. The login_hint Parameter

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] states that a Relying Party MAY include the `login_hint` parameter in an authentication request, and that its value is an identifier of the end-user. 

This profile does not define which type of identifier that is passed as a value to the `login_hint` parameter. It is context and OpenID Provider specific.

It is RECOMMENDED that a Relying Party uses the `claims` request parameter in favour of the `login_hint` parameter, see [2.1.6](the-claims-parameter) below.

<a name="the-claims-parameter"></a>
#### 2.1.6. The claims Parameter

Section 5.5 of \[[OpenID.Core](#openid-core)\] specifies how individual claims can be requested using the `claims` request parameter.

An OpenID Provider compliant with this profile MUST support the `claims` parameter, both when passed as an OAuth parameter and when included in a Request Object (see [2.1.8](#request-objects-request-and-request-uri-parameters)).

<a name="the-acr-values-and-vtr-parameters"></a>
#### 2.1.7. The acr_values and vtr Parameters

An OpenID Provider compliant with this profile MUST support the `acr_values` parameter.

> **Note**: The support for "vectors of trust" is planned for coming versions of this draft.

<a name="request-objects-request-and-request-uri-parameters"></a>
#### 2.1.8. Request Objects (request and request_uri parameters)

An OpenID Provider compliant with this profile MUST support Request Object JWT:s sent by value (using the `request` parameter) and MAY support Request Object JWT:s sent by reference (using the `request_uri` parameter).

Request objects MUST be signed by the Relying Party's registered key, and they MAY be encrypted to the OpenID Provider's public key.

See chapter 6 of \[[OpenID.Core](#openid-core)\] for further details.

<a name="pkce-parameters"></a>
#### 2.1.9. PKCE Parameters

A Relying Party MAY choose to use the Proof Key for Code Exchange (PKCE) extension, \[[RFC7636](#rfc7636)\] and include the `code_challenge` and `code_challenge_method` parameters.

If PKCE is used, the code challenge method `S256` SHOULD be used.

An OpenID Provider compliant with this profile SHOULD support the PKCE extension including support for the `S256` code challenge method.

An OpenID Provider MUST NOT allow a Relying Party to use the `plain` code challenge method.

<a name="processing-of-authentication-requests"></a>
### 2.2. Processing of Authentication Requests

An OpenID Provider compliant with this profile MUST follow the requirements stated in section 3.1.2.2 of \[[OpenID.Core](#openid-core)\].

Furthermore, the OpenID Provider MUST not proceed with the authentication if the request contains the `acr_values` request parameter and none of the specified Requested Authentication Context Class Reference values can be used to authenticate the end-user. In these cases the provider MUST respond with an `invalid_request`<sup>1</sup> error.

> \[1\]: It does not exist a specific OAuth2 or OpenID Connect error code that indicates an ACR error. Therefore, it is RECOMMENDED that the error response `error_description` includes text that informs the caller about the specific error.

<a name="token-endpoint-requests-and-id-token-issuance"></a>
## 3. Token Endpoint Requests and ID Token Issuance

This chapter declares requirements that extend, or clarify, the requirements for ID tokens in section 3.1.3 of \[[OpenID.Core](#openid-core)\].

<a name="token-requests"></a>
### 3.1. Token Requests

A Token Request MUST be sent in accordance with section 3.1.3.1 of \[[OpenID.Core](#openid-core)\] meaning that the `grant_type` is set to `authorization_code` and `code` carries the value of the code parameter returned in the authentication (authorization) response.

For client authentication requirements, see [3.1.1](#client-authentication) below.

<a name="client-authentication"></a>
#### 3.1.1. Client Authentication

In order to support legacy solutions where mutual TLS is used for client authentication this profile allows two methods for client authentication at the Token endpoint; `private_key_jwt` ([3.1.1.1](#signed-jwt-private-key-jwt)) and `client_secret_basic` ([3.1.1.2](#mutual-tls-client-secret-basic)).

OpenID Providers compliant with this profile MUST support the `private_key_jwt` method and MAY support `client_secret_basic` method if all requirements in section [3.1.1.2](#mutual-tls-client-secret-basic) are fulfilled. Any other authentication methods MUST NOT be accepted.

<a name="signed-jwt-private-key-jwt"></a>
##### 3.1.1.1. Signed JWT - private\_key\_jwt

An OpenID Provider MUST support the `private_key_jwt` authentication method according to section 9 of \[[OpenID.Core](#openid-core)\].

A Relying Party that has not registered at an OpenID Provider that allows the Mutual TLS client secret method MUST use the `private_key_jwt` authentication method which means that the following claims MUST be included in the token request:

- `client_assertion_type` - Set to `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`
- `client_assertion` - The value of the signed client authentication JWT generated. The Relying Party must generate a new assertion JWT for each call to the token endpoint.

<a name="mutual-tls-client-secret-basic"></a>
##### 3.1.1.2. Mutual TLS - client\_secret\_basic

If the OpenID Provider exposes its Token endpoint where mutual TLS<sup>1</sup> is used, and the Relying Party's identity can be established and mapped to a registered `client_id`, the provider MAY allow the `client_secret_basic` authentication method according to section 9 of \[[OpenID.Core](#openid-core)\] to be used. For all other cases the `client_secret_basic` method MUST NOT be allowed.

> \[1\]: Client and server authenticates over TLS.

<a name="token-responses-and-validation"></a>
### 3.2. Token Responses and Validation

The token response MUST include an access token (to be used to make UserInfo requests) and an ID token as described below.

<a name="id-token-contents"></a>
### 3.2.1. ID Token Contents

ID Tokens issued by OpenID Providers compliant with this profile MUST be signed and MAY be encrypted using the appropriate key of the requesting Relying Party.

Section 2 of \[[OpenID.Core](#openid-core)\] defines the contents of an ID Token. Below follows a listing of the token claims that are mandatory according to this profile along with selected optional claims for which this profile extends the requirements or descriptions given in \[[OpenID.Core](#openid-core)\].

| Token Claim | Description | Mandatory/Optional |
| :--- | :--- | :--- |
| `iss` | Issuer of the token. | Mandatory |
| `sub` | Subject identifier. See [3.2.1.1](#the-sub-token-claim) below. | Mandatory |
| `aud` | Audience of the ID Token. | Mandatory |
| `exp` | Expiration time. See [3.2.1.2](#the-exp-token-claim) below. | Mandatory |
| `iat` | Issuance time. | Mandatory |
| `auth_time` | Time when the end-user authentication occurred. In the cases where an ID Token is issued based on a previous end-user authentication, this claim MUST hold the time from the original authentication. | Mandatory |
| `nonce` | Nonce that must be matched against nonce provided in the authentication request. | Mandatory |
| `acr` | Authentication Context Class Reference. See [3.2.1.3](#the-acr-and-vot-token-claims) below. | Mandatory if `acr_values` was received in request, otherwise Optional |
| `vot` | The vector value as specified in Vectors of Trust. See [3.2.1.3](#the-acr-and-vot-token-claims) below. | Optional |
| `vtm` | Trustmark URL for vectors of trust. | Mandatory if `vot` is present, otherwise prohibited |
| `at_hash` | Access token hash value. See section 3.1.3.6 of \[[OpenID.Core](#openid-core)\] | Optional |

Except for the claims listed above the OpenID Provider also includes claims in the ID token that depends on requested scopes and claims.

<a name="the-sub-token-claim"></a>
#### 3.2.1.1. The sub Token Claim

Section 8 of \[[OpenID.Core](#openid-core)\] defines two Subject Identifier Types, `public` and `pairwise`. An OpenID Provider compliant with this profile MUST support the `public` type and SHOULD support the `pairwise` type.

In order to avoid privacy violations an OpenID Provider MUST NOT use an end-user attribute that reveals personal information about the end-user as the value for `sub`, for example a Swedish personal identity number. Even though this information may be available in other token claims, its release should be dependent on requested scopes (or claims) and not be revealed unless requested (and in some cases consented).

<a name="the-exp-token-claim"></a>
#### 3.2.1.2. The exp Token Claim

The lifetime of an ID Token should be kept as short as possible, and MUST NOT exceed 5 minutes. Shorter times are RECOMMENDED when possible.

<a name="the-acr-and-vot-token-claims"></a>
#### 3.2.1.3. The acr and vot Token Claims

If the authentication request corresponding to the ID Token being issued contained a non empty `acr_values` parameter, the `acr` claim MUST be included in the ID Token and its value MUST be one of the values supplied in `acr_values`.

If the Relying Party has registered default Authentication Context Class Reference values using the `default_acr_values` Client Metadata parameter (see section [6, Client Registration](#client-registration)) and any of those are acceptable for the OpenID provider the `acr` claim MUST be included in the ID Token and its value MUST be one of the values supplied in `default_acr_values`. 

If no `acr_values` parameter was received in the authentication request the OpenID Provider MAY include the `acr` claim.

> **Note:** The support for "vectors of trust" is planned for coming versions of this draft.

<a name="id-token-validation"></a>
### 3.2.2. ID Token Validation

Relying Parties MUST follow the requirements in section [3.1.3.7] of \[[OpenID.Core](#openid-core)\].

> TODO: Add some clarifications regarding `acr`.

<a name="claims-and-scopes"></a>
## 4. Claims and Scopes

The "Attribute Specification for the Swedish OAuth2 and OpenID Connect Profiles" document, \[[AttrSpec](#attr-spec)\], defines claims and scopes to be used within the Swedish OpenID Connect profile. This specification defines claims and scopes for many different use cases, and some definitions may not be applicable for all entities. Therefore, sections [4.1](#mandatory-identity-claims) and [4.2](#mandatory-identity-scopes) lists the claims and scopes that MUST be supported by Relying Parties and OpenID Providers that are compliant with this profile. 

<a name="mandatory-identity-claims"></a>
### 4.1. Mandatory Identity Claims

| Claim | Description | Reference |
| :--- | :--- | :--- |
| `https://claims.oidc.se/`<br />`1.0/personalNumber` | Swedish Personal Identity Number. | \[[AttrSpec](#attr-spec)\] |
| `family_name` | Family name. | \[[OpenID.Core](#openid-core)\] |
| `given_name` | Given name. | \[[OpenID.Core](#openid-core)\] |
| `name` | Display name/full name. | \[[OpenID.Core](#openid-core)\] |
| `birthdate` | Date of birth. | \[[OpenID.Core](#openid-core)\] |
| `txn` | Transaction identifier. | \[[RFC8417](#rfc8417)\] |

<a name="mandatory-identity-scopes"></a>
### 4.2. Mandatory Identity Scopes

| Scope | Description | Reference |
| :--- | :--- | :--- |
| `https://scopes.oidc.se/`<br />`1.0/naturalPersonName` | Natural Person Name Information. | \[[AttrSpec](#attr-spec)\] |
| `https://scopes.oidc.se/`<br />`1.0/naturalPersonPnr` | Natural Person Identity - Personal Number. | \[[AttrSpec](#attr-spec)\] |
| `profile` | OIDC default profile claims<sup>1</sup>. | \[[OpenID.Core](#openid-core)\] |

> \[1\]: At least `family_name`, `given_name` and `name` MUST be supported.

<a name="userinfo-endpoint"></a>
### 4.3. UserInfo Endpoint

An OpenID Provider compliant with this profile SHOULD support releasing claims from the UserInfo endpoint. If supported the OpenID Provider MUST follow the requirements from section 5.3 of \[[OpenID.Core](#openid-core)\].

Responses from the UserInfo endpoint MUST be signed.

The OpenID Provider MUST NOT release any user identity claims other than the mandatory `sub`claim if they are not explicitly requested in the original authentication request (via the `claims` parameter, see [2.1.6](#the-claims-parameter)).

<a name="claims-release-requirements"></a>
### 4.4. Claims Release Requirements

OpenID Providers MUST return claims on a best effort basis. However, an OpenID Provider asserting it can provide a user claim does not imply that this data is available for all its users. Relying Parties MUST be prepared to receive partial data. If a specific claim is requested using the `claims` request parameter is marked as `essential` (see section 5.5 of [[OpenID.Core](#openid-core)\]) and the provider can not provide this claim, the OpenID Provider MUST respond with an error response. 

An OpenID Provider compliant with this profile MUST NOT release any identity claims<sup>1</sup> in the ID token, or via the UserInfo endpoint, if they have not been explicitly requested via the `scope` and/or `claims` request parameters, or by a policy<sup>2</sup> known, and accepted, by the involved parties. 

Relying Parties requesting the `profile` scope MAY provide a `claims` request parameter. If the claims request is omitted, the OpenID Provider SHOULD provide a default claims set that it has available for the end-user, in accordance with the policy that is used. However, the OpenID Provider MUST NOT include any claims not belonging to the `profile` scope.

> \[1\]: Apart from the mandatory `sub` claim that also can be seen as an identity attribute.

> \[2\]: Such a claims release policy is out of scope for this specification.

<a name="discovery"></a>
## 5. Discovery

<a name="discovery-requirements-for-a-relying-party"></a>
### 5.1. Discovery Requirements for a Relying Party

Relying Parties SHOULD cache OpenID Provider metadata after a provider has been discovered and used by the Relying Party.

<a name="discovery-requirements-for-an-openid-provider"></a>
### 5.2. Discovery Requirements for an OpenID Provider

OpenID Providers compliant with this profile MUST support the OpenID Connect Discovery standard, \[[OpenID.Discovery](#openid-discovery)\] and adhere to the requirements defined in this chapter.

Access to the Discovery document MAY be protected with existing web authentication methods if required by the OpenID Provider. Further requirements about access management of the Discovery document is outside of the scope for this specification.

The endpoints described in the Discovery document MUST be secured in accordance with this profile.

All OpenID Providers are uniquely identified by a URL known as the issuer. This URL serves as the prefix of a service discovery endpoint as specified in \[[OpenID.Discovery](#openid-discovery)\]. 

An OpenID Provider compliant with this profile MUST present a discovery document including the mandatory/required fields specified in section 3 of \[[OpenID.Discovery](#openid-discovery)\] and meet the requirements in the table below: 

| Field | Description | Requirement |
| :--- | :--- | :--- |
| `token_endpoint` | Fully qualified URL of the OpenID Provider's OAuth 2.0 Token Endpoint. | Mandatory |
| `userinfo_endpoint` | Fully qualified URL of the OpenID Provider's UserInfo Endpoint. | Optional |
| `scopes_supported` | JSON array containing a list of the scope values that this provider supports. MUST contain `openid` value and the mandatory scopes listed in section [4.2](#mandatory-identity-scopes). | Mandatory |
| `response_types_supported` | JSON array containing a list of the OAuth 2.0 `response_type` values that the OpenID Provider supports. MUST contain the `code` type. | Mandatory |
| `acr_values_supported` | JSON array containing a list of the Authentication Context Class References that the OpenID Provider supports. | Mandatory |
| `vot` | The vectors supported by the OpenID Provider.<br />Vectors of trust support will be added in future versions of this specification. | Optional | 
| `subject_types_supported` | JSON array containing a list of the Subject Identifier types that the OpenID Provider supports. MUST contain `public` and SHOULD contain `pairwise` | Mandatory |
| `token_endpoint_auth_`<br />`methods_supported` | JSON array containing a list of client authentication methods supported by at the Token endpoint. MUST contain `private_key_jwt` and MAY contain `client_secret_basic` (if the conditions specified in section [3.1.1.2](#mutual-tls-client-secret-basic) are met). Any other method MUST NOT appear. | Mandatory |
| `token_endpoint_auth_`<br />`signing_alg_values_supported` | JSON array containing a list of JWS signing algorithms supported by the Token Endpoint for the signature on the JWT used to authenticate the client at the Token Endpoint for the `private_key_jwt`. `RS256` MUST appear, and `none` MUST NOT appear. | Mandatory |
| `claims_supported` | JSON array containing a list of the claim names of the claims that the OpenID Provider MAY be able to supply values for. This list MUST contain all mandatory claims listed in section [4.1](#mandatory-identity-claims). | Mandatory |
| `claims_parameter_supported` | Boolean value specifying whether the OpenID Provider supports use of the `claims` request parameter. Since this profile requires support the value MUST be set to `true`. | Mandatory |
| `request_parameter_supported` | Boolean value specifying whether the OpenID Provider supports use of the `request` parameter for Request Objects. Since this profile requires support the value MUST be set to `true`. | Mandatory |


Any other fields specified in \[[OpenID.Discovery](#openid-discovery)\] not appearing in the table above MAY also be used.

<a name="client-registration"></a>
## 6. Client Registration

Section 2 of \[[OpenID.Registration](#openid-registration)\] defines a listing of the client metadata used for Client Registration at the OpenID Provider. This chapter adds extra requirements and clarifications for use according to this profile.  

| Parameter | Description | Mandatory/Optional |
| :--- | :--- | :--- |
| `redirect_uris` | Array of redirection URI values used by the Relying Party. | Mandatory |
| `response_types` | The response types that the Relying Party uses. Must be set to `code`. | Mandatory |
| `grant_types` | The OAuth2 grant types the Relying Party uses. Must be set to `authorization_code`. | Mandatory |
| `jwks` | The Relying Party's JSON Web Key Set [JWK] document, passed by value. | Mandatory<br />Except for those clients that authenticate according to section [3.1.1.2](#mutual-tls-client-secret-basic). |
| `subject_type` | Subject type requested for responses to this Client. The `subject_types_supported` discovery parameter contains a list of the supported `subject_type` values for this server. Valid types include `pairwise` and `public`. The default SHOULD be `public`. See section [3.2.1.1](#the-sub-token-claim). | Optional |
| `token_endpoint_auth_method` | Authentication method for accessing the Token endpoint. MUST be one of `client_secret_basic` and `private_key_jwt`. See section [3.1.1](#client-authentication). | Mandatory |
| `default_acr_values` | Default requested Authentication Context Class Reference values. | Optional |


> **Note:** Future versions of the Swedish OpenID Connect specifications will include profiles for OpenID Connect Federation. 

<a name="security-requirements"></a>
## 7. Security Requirements

All transactions MUST be protected in transit by TLS (TODO: include reference).

All parties MUST conform to applicable recommendations in section 16, "Security Considerations" of \[[OAuth2.RFC6749](#oauth2-rfc6749)\] and those found in "OAuth 2.0 Threat Model and Security Considerations", \[[RFC6819](#rfc6819)\].

> **To discuss:** Is this too vague?

<a name="cryptographic-algorithms"></a>
### 7.1. Cryptographic Algorithms

This section lists the requirements for crypto algorithm support for being compliant with this profile.

For signature and encryption keys the following requirements apply:

- RSA public keys MUST be at least 2048 bits in length. 3072 bits or more is RECOMMENDED.
- EC public keys MUST be at least 256 bits in length (signature only). The curves NIST Curve P-256, NIST Curve P-384 and NIST Curve P-521 MUST be supported (\[[RFC5480](#rfc5480)\]).

Entities conforming to this profile MUST support the mandatory algorithms below, and SHOULD support the algorithms listed as optional.

The sender of a secure message MUST NOT use an algorithm that is not listed as mandatory in the sections below, unless it is explicitly declared by the peer in its metadata (Discovery document or Client Registration metadata).

An entity processing a message in which an algorithm not listed below has been used MUST refuse to accept the message and respond with an error, unless this algorithm has been declared as preferred or supported by the service in its metadata entry.

> This profile does not specify a complete list of blacklisted algorithms. However, there is a need to explicitly point out that the commonly used algorithm SHA-1 for digests is considered broken and SHOULD not be used or accepted.

> **TODO:** Specify mandatory and optional signature and encryption algorithms ...

<a name="normative-references"></a>
## 8. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="oauth2-rfc6749"></a>
**\[OAuth2.RFC6749\]**
> [Hardt, D., "The OAuth 2.0 Authorization Framework", RFC 6749, DOI 10.17487/RFC6749, October 2012](https://tools.ietf.org/html/rfc6749).

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="openid-discovery"></a>
**\[OpenID.Discovery\]**
> [Sakimura, N., Bradley, J., Jones, M. and E. Jay, "OpenID Connect Discovery 1.0", August 2015](https://openid.net/specs/openid-connect-discovery-1_0.html).

<a name="openid-registration"></a>
**\[OpenID.Registration\]**
> [Sakimura, N., Bradley, J., and M. Jones, “OpenID Connect Dynamic Client Registration 1.0,” November 2014](https://openid.net/specs/openid-connect-registration-1_0.html).

<a name="openid-igov"></a>
**\[OpenID.iGov\]**
> [M. Varley, P. Grassi, "International Government Assurance Profile (iGov) for OpenID Connect 1.0", October 05, 2018](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

<a name="rfc7515"></a>
**\[RFC7515\]**
> [Jones, M., Bradley, J., and N. Sakimura, “JSON Web Token (JWT)”, May 2015](https://tools.ietf.org/html/rfc7515).

<a name="rfc6819"></a>
**\[RFC6819\]**
> [Lodderstedt, T., McGloin, M. and P. Hunt, "OAuth 2.0 Threat Model and Security Considerations", RFC 6819, January 2013](https://tools.ietf.org/html/rfc6819).

<a name="rfc8417"></a>
**\[RFC8417\]**
> [P. Hunt, M. Jones, W. Denniss, M. Ansari, "Security Event Token (SET)", July 2018](https://tools.ietf.org/html/rfc8417).

<a name="rfc7636"></a>
**\[RFC7636\]**
> [Sakimura, N., Bradley, J. and N. Agarwal, "Proof Key for Code Exchange by OAuth Public Clients", RFC 7636, DOI 10.17487/RFC7636, September 2015](https://tools.ietf.org/html/rfc7636).

<a name=""></a>
**\[RFC5480\]**
> [IETF RFC 5480, Elliptic Curve Cryptography Subject Public Key Information, March 2009](https://www.ietf.org/rfc/rfc5480.txt).

<a name="attr-spec"></a>
**\[AttrSpec\]**
> [Attribute Specification for the Swedish OAuth2 and OpenID Connect Profiles](https://github.com/oidc-sweden/specifications/blob/main/swedish-oidc-attribute-specification.md).
