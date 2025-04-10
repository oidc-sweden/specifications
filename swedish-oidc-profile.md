![Logo](img/oidc-logo.png)

# The Swedish OpenID Connect Profile

### Version: 1.0 - 2023-12-11

## Abstract

This specification defines a profile for OpenID Connect for use within the Swedish public and private sectors. It profiles the OpenID Connect protocol to get a baseline security and to facilitate interoperability between relying parties and OpenID providers.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Conformance](#conformance)    

2. [**Authentication Requests and Responses**](#authentication-requests-and-responses)

    2.1. [Authentication Request Parameters](#authentication-request-parameters)   

    2.1.1. [The scope Parameter](#the-scope-parameter)
        
    2.1.2. [The state Parameter](#the-state-parameter)
    
    2.1.3. [The redirect_uri Parameter](#the-redirect-uri-parameter)
    
    2.1.4. [The prompt Parameter](#the-prompt-parameter)

    2.1.5. [The login_hint Parameter](#the-login-hint-parameter)
    
    2.1.6. [The claims Parameter](#the-claims-parameter)
    
    2.1.7. [Request Objects (request and request_uri parameters)](#request-objects-request-and-request-uri-parameters)
    
	2.1.8. [PKCE Parameters](#pkce-parameters)
		
    2.2. [Processing of Authentication Requests](#processing-of-authentication-requests)
    
    2.3. [Authentication Responses](#authentication-responses)
	
3. [**Token Endpoint Requests and ID Token Issuance**](#token-endpoint-requests-and-id-token-issuance)
    
    3.1. [Token Requests](#token-requests)
    
    3.1.1. [Client Authentication](#client-authentication)
    
    3.2. [Token Responses and Validation](#token-responses-and-validation)
    
    3.2.1. [ID Token Contents](#id-token-contents)
    
    3.2.2. [ID Token Validation](#id-token-validation)
    
4. [**Claims and Scopes**](#claims-and-scopes)
    
    4.1. [UserInfo Endpoint](#userinfo-endpoint)
    
    4.2. [Claims Release Requirements](#claims-release-requirements)

5. [**Discovery**](#discovery)

    5.1. [Discovery Requirements for a Relying Party](#discovery-requirements-for-a-relying-party)

    5.2. [Discovery Requirements for an OpenID Provider](#discovery-requirements-for-an-openid-provider)

6. [**Client Registration**](#client-registration)

7. [**Security Requirements**](#security-requirements)

    7.1. [Cryptographic Algorithms](#cryptographic-algorithms)
    
    7.2. [Signing Requirements](#signing-requirements)

8. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

This specification defines a profile for OpenID Connect for use within the Swedish public and private sector. It profiles the OpenID Connect protocol to get a baseline security and to facilitate interoperability between relying parties and OpenID providers.

> The profile is loosely based on the [International Government Assurance Profile for OpenID Connect draft](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="conformance"></a>
### 1.2. Conformance

This profile defines requirements for OpenID Connect Relying Parties (clients) and OpenID Providers (identity providers). Furthermore, it defines the interaction between a Relying Party and an OpenID Provider.

When a component compliant with this profile is interacting with other components compliant with this profile, all components MUST fully conform to the features and requirements of this specification. Any interaction with components that are not compliant with this profile is out of scope for this specification.

<a name="authentication-requests-and-responses"></a>
## 2. Authentication Requests and Responses

An OpenID Connect authentication request is a request sent to the Authorization endpoint of an OpenID Provider. These requests MUST be sent using the authorization code flow.

This chapter defines requirements for Relying Parties issuing requests and OpenID Providers processing requests that MUST be followed in order to be compliant with this profile.

<a name="authentication-request-parameters"></a>
### 2.1. Authentication Request Parameters

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] defines a set of request parameters for OpenID Connect.  

The table below lists request parameters that are mandatory according to this profile,
 along with selected optional parameters for which this profile extends the requirements or
 descriptions given in \[[OpenID.Core](#openid-core)\].

> In the table below the "Support Requirement" column indicates whether a parameter is required or
optional for a Relying Party to include in a request, and required or optional for an OP to support
and process. 

| Parameter | Description | Support Requirement |
| :--- | :--- | :--- |
| `client_id` | The client identifier valid at the OpenID Provider/Authorization Server. | REQUIRED |
| `response_type` | The response type. MUST be set to `code`. | REQUIRED |
| `scope` | Indicates the scopes requested. See [2.1.1](#the-scope-parameter) below. | REQUIRED |
| `state` | Random string generated by the Relying Party. The state is used to protect against CSRF attacks. This value is returned to the Relying Party in the authentication response. See [2.1.2](#the-state-parameter) below. | REQUIRED |
| `redirect_uri` | The endpoint where the Relying Party will receive the authentication response. See [2.1.3](#the-redirect-uri-parameter) below. | REQUIRED |
| `nonce` | String value used to associate a client session with an ID Token, and to mitigate replay attacks. The value is a (unguessable) random string generated by the Relying Party. The nonce value is returned to the Relying Party in the ID Token. | OPTIONAL for RP<br />REQUIRED for OP |
| `prompt` | Space delimited, case sensitive list of string values that specifies whether the OpenID Provider prompts the end-user for re-authentication and consent. See [2.1.4](#the-prompt-parameter) below.| OPTIONAL for RP<br />REQUIRED for OP |
| `login_hint` | Hint to the OpenID Provider about an identifier of the end-user. See [2.1.5](#the-login-hint-parameter) below. | OPTIONAL |
| `claims` | Parameter for requesting individual claims and specifying parameters that apply to the requested claims. See [2.1.6](#the-claims-parameter) below. | OPTIONAL for RP<br />REQUIRED for OP |
| `acr_values` | Requested Authentication Context Class Reference (`acr`) values.<br /><br />According to section 3.1.2.1 of  \[[OpenID.Core](#openid-core)\] the `acr` claim is requested as a voluntary claim by this parameter. A Relying Party wishing to request the `acr` claim as an essential claim should request the `acr` claim using the `claims` parameter and set it as "essential". See section [2.1.6](#the-claims-parameter) below and section 5.5.1.1 of \[[OpenID.Core](#openid-core)\]. | Optional for RP<br />Mandatory for OP |
| `request` | Request Object JWT. See [2.1.7](#request-objects-request-and-request-uri-parameters). | OPTIONAL for RP<br />REQUIRED for OP |
| `request_uri` | Request Object JWT passed by reference. See [2.1.7](#request-objects-request-and-request-uri-parameters). | OPTIONAL |
| `code_challenge`, `code_challenge_method` | Proof Key for Code Exchange (PKCE). See [2.1.8](#pkce-parameters) below. | See [2.1.8](#pkce-parameters) for RP<br />REQUIRED for OP |

<a name="the-scope-parameter"></a>
#### 2.1.1. The scope Parameter

The `scope` parameter value MUST contain `openid` and MAY contain additional scopes controlling required claims.

See section [4, Claims and Scopes](#claims-and-scopes), for further requirements concerning `scope`
processing.

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

By setting the `prompt` parameter to `none` the Relying Party instructs the OpenID Provider that no
display of any authentication or consent views is allowed, and that an error should be returned if the
user is not already authenticated at the OpenID Provider. This corresponds to the SAML authentication
request attribute `IsPassive=true`.

By setting the `prompt` parameter to `login` the Relying Party instructs the OpenID Provider that the
user MUST authenticate, and that it MUST NOT use a previous authentication session for the end-user.
This corresponds to the SAML authentication request attribute `ForceAuthn=true`. 

An OpenID Provider MUST support the `prompt` parameter according to the requirements in 
section 3.1.2.1 of \[[OpenID.Core](#openid-core)\], with the following extension: If the value of
the `prompt` parameter contains the "login" string value the OpenID Provider MUST prompt the end-user
for (re-)authentication.

<a name="the-login-hint-parameter"></a>
#### 2.1.5. The login\_hint Parameter

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] states that a Relying Party MAY include the `login_hint` parameter in an authentication request, and that its value is a string that can help the OpenID Provider to select the end-user to
authenticate.

This profile does not define which type of string that is passed as a value to the `login_hint` parameter. It is 
context- and OpenID Provider specific. 

However, a Relying Party MUST NOT use the `login_hint` to pass a claim value that it requests to be delivered in
the resulting ID Token. In these cases the `claims` request parameter SHOULD be used, see 
[2.1.6](#the-claims-parameter) below.

<a name="the-claims-parameter"></a>
#### 2.1.6. The claims Parameter

Section 5.5 of \[[OpenID.Core](#openid-core)\] specifies how individual claims can be requested using the `claims` 
request parameter.

An OpenID Provider compliant with this profile MUST support the `claims` parameter, both when passed as an OAuth
parameter and when included in a Request Object (see [2.1.7](#request-objects-request-and-request-uri-parameters)).

Section [2.1.5](#the-login-hint-parameter) states that the `claims` parameter is to be used
in favour of the `login_hint` parameter when the Relying Party needs to pass a value that it wants to be
delivered as a claim in the resulting ID Token.

The example below illustrates the contents of the `claims` parameter where the Relying Party specifies 
a value for a specific claim. By doing this instead of specifying the value as a `login_hint`, the
RP gives the OpenID Provider a more exact view of the user being authenticated.

```
{
  "id_token" : {
    "email" : { 
      "essential" : true, 
      "value" : "user@example.com" 
    }
  }
}
```

A Relying Party that has a strict requirement for deliverance of the `acr` claim in the ID Token
has the possibility to include the `acr` claim in the `claims` parameter and specify it as "essential".
Furthermore, if the RP wants to specify which Authentication Context Class Reference values that
are acceptable, the `values` parameter could be included and list these values. See section 5.5.1.1
of \[[OpenID.Core](#openid-core)\].

```
{
  "id_token" : {
    "acr": { "essential": true,
             "values": [ "https://acr.example.com/1", "https://acr.example.com/2" ] }
  }
  ...
}
```

A Relying Party specifying the `acr` claim in the `claims` parameter SHOULD NOT include the
`acr_values` parameter in the request.

<a name="request-objects-request-and-request-uri-parameters"></a>
#### 2.1.7. Request Objects (request and request_uri parameters)

An OpenID Provider compliant with this profile MUST support Request Object JWT:s sent by value
(using the `request` parameter) and MAY support Request Object JWT:s sent by reference (using
the `request_uri` parameter).

An OpenID Provider MUST be prepared to accept and process signed and/or encrypted Request Objects.

A Relying Party that signs a Request Object MUST do so using is registered key, and a Relying Party
that encrypts a Request Object MUST do so using the OpenID Provider's public key.

If a Request Object is signed it MUST contain the `iss` (issuer) and `aud` (audience) claims.

The `iss` value MUST be the client ID of the Relying Party (unless it was signed by a different
party than the RP). 

The `aud` value SHOULD be set to the OpenID Provider's Issuer Identifier URL. 
\[[OpenID.Core](#openid-core)\] also allows for this value to be an URL including the OP Issuer
Identifier URL. In practice this means that the OP Authorization Endpoint URL may be used.
Therefore, an OpenID Provider compliant with this profile MUST accept `aud` values that are either
the OP Issuer Identifier URL or the Authorization Endpoint on which an authentication request was
received.  

A Relying Party sending an authentication request containing a Request Object SHOULD use the
`POST` method to do so. Since the contents of the `request` parameter is signed the payload may
become too large for using `GET`.

See chapter 6 of \[[OpenID.Core](#openid-core)\] for further details.

<a name="pkce-parameters"></a>
#### 2.1.8. PKCE Parameters

Regular Relying Parties (i.e., not *Public Clients*) SHOULD use the Proof Key for Code Exchange (PKCE)
extension, \[[RFC7636](#rfc7636)\] and include the `code_challenge` and `code_challenge_method`
parameters.

A "Public Client", i.e., a browser-based web application or a native mobile app with no backend logic,
MUST use PKCE and include the `code_challenge` and `code_challenge_method` parameters in the
authentication request.

When PKCE is used, the code challenge method `S256` SHOULD be used.

An OpenID Provider compliant with this profile MUST support the PKCE extension including support
for the `S256` code challenge method.

An OpenID Provider MUST NOT allow a Relying Party to use the `plain` code challenge method.

<a name="processing-of-authentication-requests"></a>
### 2.2. Processing of Authentication Requests

An OpenID Provider compliant with this profile MUST follow the requirements stated in 
section 3.1.2.2 of \[[OpenID.Core](#openid-core)\] and the requirements put in 
[section 2.1](#authentication-request-parameters) of this profile.

Furthermore, the OpenID Provider MUST NOT proceed with the authentication if the request contains
a `claims` parameter including essential `acr` values and none of the specified Requested 
Authentication Context Class Reference values can be used to authenticate the end-user. In these
cases the provider SHOULD respond with an `unmet_authentication_requirements` error as defined in
\[[OpenID.Unmet-AuthnReq](#openid-unmet-authnreq)\]. 
See section 5.5.1.1 of \[[OpenID.Core](#openid-core)\].

<a name="authentication-responses"></a>
### 2.3. Authentication Responses

Entities compliant with this profile MUST follow the requirements regarding authentication error
responses put in section 3.1.2.6 of \[[OpenID.Core](#openid-core)\].

OpenID Providers SHOULD limit the use of error codes to the sets defined in:

- Section 4.1.2.1 of \[[OAuth2.RFC6749](#oauth2-rfc6749)\],

- section 3.1.2.6 of \[[OpenID.Core](#openid-core)\], and, 

- \[[OpenID.Unmet-AuthnReq](#openid-unmet-authnreq)\].

All error codes defined in the OpenID Connect and OAuth2 specifications except for `access_denied`
represent error conditions that are caused by either an invalid request or conditions/requirements 
that can not be met, where `access_denied` represents that the authentication process was not
completed. 

A non-completed authentication process may be caused by:

- the user denies, or cancels, the authentication process, or, 

- the user agrees to authenticate, but the authentication operation fails. 

In the latter case the OpenID Provider MUST inform the user about the error that occurred
before responding with an error response.

In both above scenarios the `error_description`-field of the error response SHOULD be set and
contain a description suitable for the Relying Party application logs.

<a name="token-endpoint-requests-and-id-token-issuance"></a>
## 3. Token Endpoint Requests and ID Token Issuance

This chapter declares requirements that extend, or clarify, the requirements for ID Tokens in 
section 3.1.3 of \[[OpenID.Core](#openid-core)\].

<a name="token-requests"></a>
### 3.1. Token Requests

A Token Request MUST be sent in accordance with section 3.1.3.1 of \[[OpenID.Core](#openid-core)\]
meaning that the `grant_type` is set to `authorization_code` and `code` carries the value of the
code parameter returned in the authentication (authorization) response.

If PKCE parameters were sent in the authentication request, see section [2.1.8](#pkce-parameters) 
above, the Token Request MUST include the PKCE `code_verifier` parameter, and the OpenID Provider
MUST process this parameter according to section 4.6 of \[[RFC7636](#rfc7636)\].

For client authentication requirements, see [3.1.1](#client-authentication) below.

<a name="client-authentication"></a>
#### 3.1.1. Client Authentication

OpenID Providers compliant with this profile MUST support the `private_key_jwt` method for client authentication at the Token endpoint, and MAY support other methods if permitted by the context
or policy under which the OP is functioning.

If Mutual TLS authentication is supported and used, the requirements stated in section 2 of 
\[[RFC8705](#rfc8705)\] MUST be followed.

A Relying Party SHOULD default to use the `private_key_jwt` method, and in these cases the following
claims MUST be included in the token request:

- `client_assertion_type` - Set to `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`
- `client_assertion` - The value of the signed client authentication JWT generated. The Relying Party must generate a new assertion JWT for each call to the token endpoint.

Section 9 of \[[OpenID.Core](#openid-core)\] lists the required contents of the signed JWT. These
requirements states that the `aud` claim value SHOULD be set to the URL of the OpenID Provider's Token
endpoint. In order to facilitate interoperability it is RECOMMENDED that an OpenID Provider compliant 
with this profile also accepts its Issuer Identifier URL as a valid value for the `aud` claim.

<a name="token-responses-and-validation"></a>
### 3.2. Token Responses and Validation

The token response MUST include an access token (to be used to make UserInfo requests) and an ID Token as described below.

<a name="id-token-contents"></a>
### 3.2.1. ID Token Contents

ID Tokens issued by OpenID Providers compliant with this profile MUST be signed and MAY be
encrypted using the appropriate key of the requesting Relying Party.

Section 2 of \[[OpenID.Core](#openid-core)\] defines the contents of an ID Token. Below follows a
listing of the token claims that are mandatory according to this profile along with selected optional
claims for which this profile extends the requirements or descriptions given in 
\[[OpenID.Core](#openid-core)\].

| Token Claim | Description | Requirement |
| :--- | :--- | :--- |
| `iss` | Issuer of the token. | REQUIRED |
| `sub` | Subject identifier. See [3.2.1.1](#the-sub-token-claim) below. | REQUIRED |
| `aud` | Audience of the ID Token. | REQUIRED |
| `exp` | Expiration time. See [3.2.1.2](#the-exp-token-claim) below. | REQUIRED |
| `iat` | Issuance time. | REQUIRED |
| `auth_time` | Time when the end-user authentication occurred. In the cases where an ID Token is issued based on a previous end-user authentication, this claim MUST hold the time from the original authentication. | REQUIRED |
| `nonce` | Nonce that must be matched against nonce provided in the authentication request. | OPTIONAL |
| `acr` | Authentication Context Class Reference. See [3.2.1.3](#the-acr-claim) below. | REQUIRED if the `acr` claim was requested as an essential claim (see [2.1](#authentication-request-parameters) above), otherwise OPTIONAL. |

Except for the claims listed above the OpenID Provider also includes claims in the ID Token that
depends on requested scopes and claims.

<a name="the-sub-token-claim"></a>
#### 3.2.1.1. The sub Token Claim

Section 8 of \[[OpenID.Core](#openid-core)\] defines two Subject Identifier Types, `public` and
`pairwise`. An OpenID Provider compliant with this profile MUST support the `public` type and 
SHOULD support the `pairwise` type.

In order to avoid privacy violations an OpenID Provider MUST NOT use an end-user attribute that
reveals personal information about the end-user as the value for `sub`, for example a personal
identity number. Even though this information may be available in other token claims, its release
should be dependent on requested scopes (or claims) and not be revealed unless explicitly
requested (and in some cases consented).

<a name="the-exp-token-claim"></a>
#### 3.2.1.2. The exp Token Claim

The lifetime of an ID Token should be kept as short as possible, and MUST NOT exceed 5 minutes. Shorter times are RECOMMENDED when possible.

<a name="the-acr-claim"></a>
#### 3.2.1.3. The acr Claim

An OpenID Provider compliant with this profile MUST adhere to section 5.5.1.1 of
\[[OpenID.Core](#openid-core)\] regarding issuance of the `acr` claim.

<a name="id-token-validation"></a>
### 3.2.2. ID Token Validation

Relying Parties MUST follow the requirements in section 3.1.3.7 of \[[OpenID.Core](#openid-core)\].

<a name="claims-and-scopes"></a>
## 4. Claims and Scopes

<a name="userinfo-endpoint"></a>
### 4.1. UserInfo Endpoint

An OpenID Provider compliant with this profile MUST support releasing claims from the UserInfo
endpoint and MUST follow the requirements from section 5.3 of \[[OpenID.Core](#openid-core)\].

Access to the UserInfo endpoint MUST be denied if a valid access token is not presented.

Responses from the UserInfo endpoint MUST be signed.

See section [4.2](#claims-release-requirements) below for claims release requirements via the
UserInfo endpoint.

Relying Parties MUST follow section 5.3.4 of \[[OpenID.Core](#openid-core)\] when validating a
UserInfo response message.

<a name="claims-release-requirements"></a>
### 4.2. Claims Release Requirements

OpenID Providers MUST return claims on a best effort basis. However, an OpenID Provider asserting
it can provide a user claim does not imply that this data is available for all its users. Relying
Parties MUST be prepared to receive partial data. 

An OpenID Provider MUST NOT release any claim to a Relying Party that it has not been authorized
to receive. How this authorization is handled and managed is out of scope for this profile. 

An OpenID Provider compliant with this profile MUST NOT release any identity claims in the ID Token,
or via the UserInfo endpoint, if they have not been explicitly requested via `scope` and/or `claims`
request parameters, or indirectly by a policy known, and accepted, by the involved parties.

The above requirement does not include the mandatory `sub` claim, and claims that do not reveal 
identity information about the user, for example, transaction identifiers or claims holding
information about the authentication process.

An OpenID Provider compliant with this profile MUST adhere to the following rules for release
of identity claims belonging to the subject:

- If a `claims` request parameter is included in the authentication request, the claims contained
in this parameter are delivered according to their indicated destination (`id_token` or `userinfo`).

- If a `scope` request parameter value is included in the authentication request, and this scope
definition has specific claims delivery requirements (i.e., whether the claims belonging to the
scope should be delivered in ID Token or via the UserInfo endpoint), the claims are delivered
according to these scope requirements.

- If none of the above rules apply, claims are delivered via the UserInfo endpoint, as specified by 
\[[OpenID.Core](#openid-core)\].

In cases where a claim is delivered in the ID Token due to a specific `claims` parameter
request, and this claim is part of a standard or custom scope that states delivery via the UserInfo
endpoint (which is the default), the claim MUST also be delivered via the UserInfo endpoint (if the
scope in question is requested).

<a name="discovery"></a>
## 5. Discovery

<a name="discovery-requirements-for-a-relying-party"></a>
### 5.1. Discovery Requirements for a Relying Party

Relying Parties SHOULD cache OpenID Provider metadata after a provider has been discovered and used by the Relying Party.

<a name="discovery-requirements-for-an-openid-provider"></a>
### 5.2. Discovery Requirements for an OpenID Provider

OpenID Providers compliant with this profile MUST support the OpenID Connect Discovery standard,
\[[OpenID.Discovery](#openid-discovery)\] and adhere to the requirements defined in this chapter.

Access to the Discovery document MAY be protected with existing web authentication methods if
required by the OpenID Provider. Further requirements about access management of the Discovery
document is outside of the scope for this specification.

The endpoints described in the Discovery document MUST be secured in accordance with this profile.

All OpenID Providers are uniquely identified by a URL known as the issuer. This URL serves as the
prefix of a service discovery endpoint as specified in \[[OpenID.Discovery](#openid-discovery)\]. 

An OpenID Provider compliant with this profile MUST present a discovery document including the
required fields specified in section 3 of \[[OpenID.Discovery](#openid-discovery)\] **and** meet
the requirements in the table below: 

| Field | Description | Requirement |
| :--- | :--- | :--- |
| `token_endpoint` | Fully qualified URL of the OpenID Provider's OAuth 2.0 Token Endpoint. | REQUIRED |
| `userinfo_endpoint` | Fully qualified URL of the OpenID Provider's UserInfo Endpoint. | REQUIRED |
| `jwks_uri` | URL of the OP's JSON Web Key Set \[[JWK](#rfc7517)\] document.<br />To facilitate a smooth key rollover, each JWK of the referenced document SHOULD include a `kid` parameter. See section 4.5 of \[[RFC7517](#rfc7517)\]. | REQUIRED |
| `scopes_supported` | JSON array containing a list of the scope values that this provider supports. MUST contain the `openid` value. | REQUIRED |
| `response_types_supported` | JSON array containing a list of the OAuth 2.0 `response_type` values that the OpenID Provider supports. MUST contain the `code` type. | REQUIRED |
| `acr_values_supported` | JSON array containing a list of the Authentication Context Class References that the OpenID Provider supports. | REQUIRED |
| `subject_types_supported` | JSON array containing a list of the Subject Identifier types that the OpenID Provider supports. MUST contain `public` and SHOULD contain `pairwise` | REQUIRED |
| `token_endpoint_auth_`<br />`methods_supported` | JSON array containing a list of client authentication methods supported by at the Token endpoint. MUST contain `private_key_jwt` and MAY contain other authentication methods as specified in section 9 of \[[OpenID.Core](#openid-core)\] or \[[RFC8705](#rfc8705)\] for Mutual TLS. | REQUIRED |
| `token_endpoint_auth_`<br />`signing_alg_values_supported` | JSON array containing a list of JWS signing algorithms supported by the Token Endpoint for the signature on the JWT used to authenticate the client at the Token Endpoint for the `private_key_jwt`. `RS256` and `ES256` MUST appear, and `none` MUST NOT appear.  See section [7.1](#cryptographic-algorithms) below.| REQUIRED |
| `claims_supported` | JSON array containing a list of the claim names of the claims that the OpenID Provider MAY be able to supply values for. | REQUIRED |
| `claims_parameter_supported` | Boolean value specifying whether the OpenID Provider supports use of the `claims` request parameter. Since this profile requires support the value MUST be set to `true`. | REQUIRED |
| `request_parameter_supported` | Boolean value specifying whether the OpenID Provider supports use of the `request` parameter for Request Objects. Since this profile requires support the value MUST be set to `true`. | REQUIRED |
| `code_challenge_methods_supported` | JSON array containing a list of PKCE code challenge methods supported by this OP. The array MUST include the `S256` method and MUST NOT include the `plain` method.<br />The `code_challenge_methods_supported` parameter is defined in section 2 of \[[RFC8414](#rfc8414)\]. | REQUIRED |

Any other fields specified in \[[OpenID.Discovery](#openid-discovery)\] not appearing in the table above MAY also be used.

<a name="client-registration"></a>
## 6. Client Registration

Section 2 of \[[OpenID.Registration](#openid-registration)\] defines a listing of the client metadata used for Client Registration at the OpenID Provider. This chapter adds extra requirements and clarifications for use according to this profile.  

The profile does not mandate OpenID Provider support for Dynamic registration of Relying Parties (clients). However, an OpenID Provider compliant with this profile MUST still be able to handle the client registration parameters specified in this section and in section 2 of \[[OpenID.Registration](#openid-registration)\]. This means that if an OpenID Provider
registers Relying Parties by other means, it MUST gather and maintain all required client information parameters in the
following table.

| Parameter | Description | Requirement |
| :--- | :--- | :--- |
| `redirect_uris` | Array of redirection URI values used by the Relying Party. | REQUIRED |
| `response_types` | The response types that the Relying Party uses. Must be set to `code`. | REQUIRED |
| `grant_types` | The OAuth2 grant types the Relying Party uses. Must be set to `authorization_code`. | REQUIRED |
| `jwks`<br />`jwks_uri` | The Relying Party's JSON Web Key Set \[[JWK](#rfc7517)\] document, passed by value or reference (URI).<br />To facilitate a smooth key rollover, each JWK of the referenced document SHOULD include a `kid` parameter. See section 4.5 of \[[RFC7517](#rfc7517)\]. | At least one of `jwks` or `jwks_uri` is REQUIRED.<br />Except for those clients that authenticate according to the exceptions described in section [3.1.1](#client-authentication). |
| `subject_type` | Subject type requested for responses to this Client. The `subject_types_supported` discovery parameter contains a list of the supported `subject_type` values for this server. Valid types include `pairwise` and `public`. The default SHOULD be `public`. See section [3.2.1.1](#the-sub-token-claim). | OPTIONAL |
| `token_endpoint_auth_method` | Authentication method for accessing the Token endpoint. See section [3.1.1](#client-authentication). | REQUIRED |
| `default_acr_values` | Default requested Authentication Context Class Reference values. | OPTIONAL |

<a name="security-requirements"></a>
## 7. Security Requirements

All transactions MUST be protected in transit by TLS as described in \[[NIST.800-52.Rev2](#nist800-52)\]. 

All parties MUST conform to applicable recommendations in section 16, "Security Considerations" of \[[OAuth2.RFC6749](#oauth2-rfc6749)\] and those found in "OAuth 2.0 Threat Model and Security Considerations", \[[RFC6819](#rfc6819)\].

<a name="cryptographic-algorithms"></a>
### 7.1. Cryptographic Algorithms

This section lists the requirements for cryptographic algorithm support for being compliant with
this profile.

All entities compliant with this profile MUST follow the guidelines in 
\[[NIST.800-131A.Rev2](#nist800-131)\] regarding use of algorithms and key lengths<sup>1</sup>.
Specifically, for signature and encryption keys the following requirements apply:

- RSA public keys MUST be at least 2048 bits in length.
- EC public keys MUST be at least 256 bits in length (signature only). The curve NIST Curve P-256 MUST be 
supported (\[[RFC5480](#rfc5480)\]), and NIST Curve P-384 and NIST Curve P-521 SHOULD be supported.

Entities conforming to this profile MUST support algorithms according to "JSON Web Algorithms (JWA)", 
\[[RFC7518](#rfc7518)\], with the following additions:

- `RS256`, RSASSA-PKCS1-v1_5 using SHA-256, is listed as recommended in \[[RFC7518](#rfc7518)\], but is
REQUIRED to support by this profile.

- `RS384`, RSASSA-PKCS1-v1_5 using SHA-384, is listed as optional in \[[RFC7518](#rfc7518)\],
but is RECOMMENDED to support by this profile.

- `RS512`, RSASSA-PKCS1-v1_5 using SHA-512, is listed as optional in \[[RFC7518](#rfc7518)\],
but is RECOMMENDED to support by this profile.

- `ES256`, ECDSA using P-256 and SHA-256, is listed as recommended in \[[RFC7518](#rfc7518)\], but
is REQUIRED to support by this profile.

- `ES384`, ECDSA using P-384 and SHA-384, is listed as optional in \[[RFC7518](#rfc7518)\], but is 
RECOMMENDED to support by this profile.

- `ES512`, ECDSA using P-521 and SHA-512, is listed as optional in \[[RFC7518](#rfc7518)\], but is
RECOMMENDED to support by this profile.

- `RSA-OAEP`, RSAES OAEP using default parameters, is listed as recommended in \[[RFC7518](#rfc7518)\],
but is REQUIRED to support by this profile.

- `A128GCM` and `A256GCM`, AES GCM using 128/256-bit key, are listed as recommended in \[[RFC7518](#rfc7518)\],
but are REQUIRED by this profile.

The sender of a secure message MUST NOT use an algorithm that is not set as REQUIRED in \[[RFC7518](#rfc7518)\]
or in the listing above, unless it is explicitly declared by the peer in its metadata (Discovery document
or Client Registration metadata).

> \[1\]: \[[NIST.800-131A.Rev2](#nist800-131)\] contains a listing of algorithms that must not be used.
However, there is a need to explicitly point out that the commonly used algorithm SHA-1 for digests is 
considered broken and MUST NOT be used or accepted.

<a name="signing-requirements"></a>
### 7.2. Signing Requirements

Entities compliant with this profile MUST follow the requirements from section section 10.1 
of \[[OpenID.Core](#openid-core)\]. This section states the following:

> If there are multiple keys in the referenced JWK Set document, a `kid` value MUST be provided in the JOSE Header.

In order to facilitate for rotation/update of asymmetric keys and to enable for the receiving entity to
dynamically update the sender's JWK Set document entities compliant with this profile SHOULD include the 
`kid` value also in the cases where its `jwks` only contains one (signing) key. 

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

<a name="openid-unmet-authnreq"></a>
**\[OpenID.Unmet-AuthnReq\]**
> [T. Lodderstedt, "OpenID Connect Core Error Code unmet\_authentication\_requirements"](https://openid.net/specs/openid-connect-unmet-authentication-requirements-1_0.html).

<a name="openid-discovery"></a>
**\[OpenID.Discovery\]**
> [Sakimura, N., Bradley, J., Jones, M. and E. Jay, "OpenID Connect Discovery 1.0", August 2015](https://openid.net/specs/openid-connect-discovery-1_0.html).

<a name="openid-registration"></a>
**\[OpenID.Registration\]**
> [Sakimura, N., Bradley, J., and M. Jones, “OpenID Connect Dynamic Client Registration 1.0,” November 2014](https://openid.net/specs/openid-connect-registration-1_0.html).

<a name="rfc7515"></a>
**\[RFC7515\]**
> [Jones, M., Bradley, J., and N. Sakimura, “JSON Web Signature (JWS)”, May 2015](https://tools.ietf.org/html/rfc7515).

<a name="rfc7517"></a>
**\[RFC7517\]**
> [Jones, M., "JSON Web Key (JWK)", May 2015](https://datatracker.ietf.org/doc/html/rfc7517).

<a name="rfc7518"></a>
**\[RFC7518\]**
> [Jones, M., "JSON Web Algorithms (JWA)", May 2015](https://www.rfc-editor.org/rfc/rfc7518.txt).

<a name="rfc7519"></a>
**\[RFC7519\]**
> [Jones, M., Bradley, J. and N. Sakimura, "JSON Web Token (JWT)", May 2015](https://datatracker.ietf.org/doc/html/rfc7519).

<a name="rfc8705"></a>
**\[RFC8705\]**
> [B. Campbell, J. Bradley, N. Sakimura, T. Lodderstedt, "OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens", February 2020](https://datatracker.ietf.org/doc/html/rfc8705).

<a name="rfc8414"></a>
**\[RFC8414\]**
> [Jones, M., Bradley, J., and N. Sakimura, "OAuth 2.0 Authorization Server Metadata", June 2018](https://www.rfc-editor.org/rfc/rfc8414.html).

<a name="rfc6819"></a>
**\[RFC6819\]**
> [Lodderstedt, T., McGloin, M. and P. Hunt, "OAuth 2.0 Threat Model and Security Considerations", RFC 6819, January 2013](https://tools.ietf.org/html/rfc6819).

<a name="rfc7636"></a>
**\[RFC7636\]**
> [Sakimura, N., Bradley, J. and N. Agarwal, "Proof Key for Code Exchange by OAuth Public Clients", RFC 7636, DOI 10.17487/RFC7636, September 2015](https://tools.ietf.org/html/rfc7636).

<a name="rfc5480"></a>
**\[RFC5480\]**
> [IETF RFC 5480, Elliptic Curve Cryptography Subject Public Key Information, March 2009](https://www.ietf.org/rfc/rfc5480.txt).

<a name="nist800-52"></a>
**\[NIST.800-52.Rev2\]**
> [NIST Special Publication 800-52, Revision 2, "Guidelines for the Selection, Configuration, and Use of Transport Layer Security (TLS) Implementations"](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf). 

<a name="nist800-131"></a>
**\[NIST.800-131A.Rev2\]**
> [NIST Special Publication 800-131A Revision 2, "Transitioning the Use of Cryptographic Algorithms and Key Lengths"](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar2.pdf)

