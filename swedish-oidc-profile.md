# The Swedish OpenID Connect Profile

### Version: 1.0 - draft 01 - 2021-04-08

## Abstract

This specification defines a profile for OpenID Connect for use within the Swedish public and private sector. It profiles the OpenID Connect protocol to get a baseline security and to facilitate interoperability between relying parties and OpenID providers.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Conformance](#conformance)
    
2. [**Relying Party Requirements**](#relying-party-requirements)

    2.1. [Authentication Requests](#authentication-requests)

    2.1.1. [The scope Parameter](#the-scope-parameter)
        
    2.1.2. [The state Parameter](#the-state-parameter)
    
    2.1.3. [The prompt Parameter](#the-prompt-parameter)

    2.1.4. [The login_hint Parameter](#the-login-hint-parameter)
    
    2.1.5. [The claims Parameter](#the-claims-parameter)
    
    2.1.5. [The acr_values and vtr Parameters](#the-acr-values-and-vtr-parameters)
    
    2.1.6. [Request Objects (request and request_uri parameters)](#request-objects-request-and-request-uri-parameters)
    
    2.2. [Token Endpoint Requests](#token-endpoint-requests)
    
    2.3. [Processing of ID Tokens](#processing-of-id-tokens)
    
    2.4. [Discovery](#rp-discovery)

3. [**OpenID Provider Requirements**](#openid-provider-requirements)

    3.1. [Processing of Authentication Requests](#processing-of-authentication-requests)
    
    3.2. [Authentication Responses](#authentication-responses)
    
    3.2.1. [ID Tokens](#id-tokens)
    
    3.3. [The UserInfo Endpoint](#the-userinfo-endpoint)
    
    3.4. [Discovery](#op-discovery)
    
4. [**Claims and Scopes**](#claims-and-scopes)

5. [**Security Requirements**](#security-requirements)

    5.1. [Cryptographic Algorithms](#cryptographic-algorithms)

6. [**Normative References**](#normative-references)

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

<a name="relying-party-requirements"></a>
## 2. Relying Party Requirements

This chapter defines requirements that OpenID Connect Relying Parties MUST adhere to in order to be compliant with this profile.

<a name="authentication-requests"></a>
### 2.1. Authentication Requests

An OpenID Connect authentication request is a request sent to the Authorization endpoint of an OpenID Provider. 

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] defines a set of request parameters for OpenID Connect.  

Below follows a table with request parameters that are mandatory according to this profile along with selected optional parameters for which this profile extends the requirements or descriptions given in \[[OpenID.Core](#openid-core)\].


| Parameter | Description | Mandatory/Optional |
| :--- | :--- | :--- |
| `client_id` | The client identifier valid at the OpenID Provider/Authorization Server. | Mandatory |
| `response_type` | The response type. MUST be set to `code`. | Mandatory |
| `scope` | Indicates the scopes requested. See [2.2.1](#the-scope-parameter) below. | Mandatory |
| `state` | Random string generated by the Relying Party. The state is used to protect against CSRF attacks. This value is returned to the Relying Party in the authentication response. See [2.2.2](#the-state-parameter) below. | Mandatory |
| `redirect_uri` | The endpoint where the Relying Party will receive the authentication response. This value MUST be the complete URI. | Mandatory |
| `nonce` | String value used to associate a client session with an ID Token, and to mitigate replay attacks. The value is a (unguessable) random string generated by the Relying Party. The nonce value is returned to the Relying Party in the ID Token. | Mandatory |
| `prompt` | Space delimited, case sensitive list of string values that specifies whether the OpenID Provider prompts the end-user for re-authentication and consent. See [2.1.3](#the-prompt-parameter) below.| Optional |
| `login_hint` | Hint to the OpenID Provider about an identifier of the end-user. [2.1.4](#the-login-hint-parameter) below. | Optional |
| `claims` | Parameter for requesting individual claims and specifying parameters that apply to the requested claims. See [2.1.5](the-claims-parameter) below. | Optional |
| `acr_values` | Requested Authentication Context Class Reference values. See [2.1.6](#the-acr-values-and-vtr-parameters) below. | Optional |
| `vtr` | Requested Vectors-of-trust. See [2.1.6](#the-acr-values-and-vtr-parameters) below. | Optional |
| `request` | Request Object JWT. See [2.1.7](#request-objects-request-and-request-uri-parameters). | Optional |
| `request_uri` | Request Object JWT passed by reference. See [2.1.7](#request-objects-request-and-request-uri-parameters). | Optional |


> To disuss: Should we write anything about PKCE extension (Proof Key for Code Exchange) and the `code_challenge` and `code_challenge_method` parameters?

<a name="the-scope-parameter"></a>
#### 2.1.1. The scope Parameter

The `scope` parameter value MUST contain `openid` and MAY contain additional scopes controlling required claims.

> TODO: refer to the attribute specification. 

> To discuss: If a component is compliant with this specification which scopes from the attribute spec must it support?

<a name="the-state-parameter"></a>
#### 2.1.2. The state Parameter

Relying Parties MUST use an unguessable random value for the `state` parameter, where the value has at least 128 bits of entropy. 

Relying Parties MUST validate the value of the `state` parameter upon return to the redirect URI and MUST ensure that the value is tied to the current session of the user.

<a name="the-prompt-parameter"></a>
#### 2.1.3. The prompt Parameter

A Relying Party may use the `prompt` parameter to control, or prevent, Single Sign On.

By setting the `prompt` parameter to `none` it instructs the OpenID Provider that no display of any authentication or consent views is allowed, and that an error should be returned if the user is not already authenticated at the OpenID Provider. This corresponds to the SAML authentication request attribute `IsPassive=true`.

By setting the `prompt` parameter to `login` the Relying Party instructs the OpenID Provider that the user MUST authenticate, and that it MUST NOT use a previous authentication session for the end-user. This corresponds to the SAML authentication request attribute `ForceAuthn=true`. 

<a name="the-login-hint-parameter"></a>
#### 2.1.4. The login_hint Parameter

Section 3.1.2.1 of \[[OpenID.Core](#openid-core)\] states that a Relying Party MAY include the `login_hint` parameter in an authentication request, and that its value is an identifier of the end-user. 

This profile does not define which type of identifier that is passed as a value to the `login_hint` parameter. It is context and OpenID Provider specific.

It is RECOMMENDED that a Relying Party uses the `claims` request parameter in favour of the `login_hint` parameter, see [2.1.5](the-claims-parameter) below.

<a name="the-claims-parameter"></a>
#### 2.1.5. The claims Parameter

TODO

<a name="the-acr-values-and-vtr-parameters"></a>
#### 2.1.6. The acr_values and vtr Parameters

TODO

To discuss: Should we require OpenID Provider support for VoT?

<a name="request-objects-request-and-request-uri-parameters"></a>
#### 2.1.7. Request Objects (request and request_uri parameters)

TODO

<a name="token-endpoint-requests"></a>
### 2.2. Token Endpoint Requests

TODO: Requirements for requests to the token endpoint

TODO: `grant_type` MUST be `authorization_code`.

**To discuss:** 
- Client authentication. Chapter 9 of \[[OpenID.Core](#openid-core)\].
- Suggestion: Use `private_key_jwt` that would imply the the `client_assertion_type` is set to `urn:ietf:params:oauth:client-assertion-type:jwt-bearer` and that the `client_assertion` parameter is the value of the signed client authentication JWT.

- Will this be too complex for some customers to BankID/Freja. Allow `client_secret_basic` for some applications?

<a name="processing-of-id-tokens"></a>
### 2.3. Processing of ID Tokens

TODO: Specify requirements on the processing and validation of an ID token

<a name="rp-discovery"></a>
### 2.4. Discovery

Relying Parties SHOULD cache OpenID Provider metadata when an OpenID Provider has been discovered and used by the RP.

TODO: More here

<a name="openid-provider-requirements"></a>
## 3. OpenID Provider Requirements

This chapter defines requirements that OpenID Connect Providers MUST adhere to in order to be compliant with this profile.

<a name="processing-of-authentication-requests"></a>
### 3.1. Processing of Authentication Requests

An OpenID Provider compliant with this profile MUST follow the requirements stated in section 3.1.2.2 of \[[OpenID.Core](#openid-core)\] along with the additional requirements stated below.

TODO: MUST support request objects.

TODO: Vectors-of-trust vs. authentication context values.

### 3.1.X. redirect_uri

An OpenID Relying Party MUST include the complete redirect URI as a `redirect_uri` parameter value. In order to prevent open redirection and other injection attacks, the OpenID Provider MUST match the entire URI using a direct string comparison against registered values and MUST reject requests with an invalid or missing redirect URI.

### 3.1.X. prompt

TODO: Must be supported.

### 3.1.X. login_hint

TODO: An OpenID Provider MUST also support the `claims` parameter in a Request Object. ...

<a name="authentication-responses"></a>
### 3.2. Authentication Responses

TODO: ID-token, access token (and refresh-token).

<a name="id-tokens"></a>
#### 3.2.1. ID Tokens

TODO: Requirements for the contents and compilation of ID tokens.

**To discuss:** Restrictions on `sub` claim. Don't use a "personnummer" there unless the OP only handles one ID scope.

**To discuss:** Requirements for pairwise identifiers = different subject identifier (sub) for every client the user connects to

<a name="the-userinfo-endpoint"></a>
### 3.3. The UserInfo Endpoint

**To discuss:** Should we require that an OP supports the UserInfo endpoint?

<a name="op-discovery"></a>
### 3.4. Discovery

TODO: Specify what is required to include in the OP discovery document.

<a name="claims-and-scopes"></a>
## 4. Claims and Scopes

TODO: Point at the attribute specification.

**To discuss:** Compliance to this profile should not mean that all claims and scopes defined in the attribute specification must be supported. Where do we draw the line?

<a name="security-requirements"></a>
## 5. Security Requirements

All transactions MUST be protected in transit by TLS (TODO: include reference).

All parties MUST conform to applicable recommendations in section 16, "Security Considerations" of \[[OAuth2.RFC6749](#oauth2-rfc6749)\] and those found in "OAuth 2.0 Threat Model and Security Considerations", \[[RFC6819](#rfc6819)\].

> **To discuss:** Is this too vague?

<a name="cryptographic-algorithms"></a>
### 5.1. Cryptographic Algorithms

TODO

See Section 8 of [Deployment Profile for the Swedish eID Framework](https://docs.swedenconnect.se/technical-framework/latest/02_-_Deployment_Profile_for_the_Swedish_eID_Framework.html#cryptographic-algorithms) as a starting point.

<a name="normative-references"></a>
## 6. Normative References

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

<a name="openid-igov"></a>
**\[OpenID.iGov\]**
> [M. Varley, P. Grassi, "International Government Assurance Profile (iGov) for OpenID Connect 1.0", October 05, 2018](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

<a name="rfc7515"></a>
**\[RFC7515\]**
> [Jones, M., Bradley, J., and N. Sakimura, “JSON Web Token (JWT)”, May 2015](https://tools.ietf.org/html/rfc7515).

<a name="rfc6819"></a>
**\[RFC6819\]**
> [Lodderstedt, T., McGloin, M. and P. Hunt, "OAuth 2.0 Threat Model and Security Considerations", RFC 6819, January 2013](https://tools.ietf.org/html/rfc6819).
