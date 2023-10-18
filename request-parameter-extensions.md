![Logo](img/oidc-logo.png)

# Authentication Request Parameter Extensions for the Swedish OpenID Connect Profile

### Version: 1.0 - draft 02 - 2023-10-18

## Abstract

This specification defines authentication request parameter extensions for the Swedish OpenID
Connect Profile.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Conformance](#conformance)    

2. [**Authentication Request Parameter Extensions**](#authentication-request-parameter-extensions)
	
    2.1. [Client Provided User Message](#client-provided-user-message)
    
    2.2. [Requested Authentication Provider](#requested-authentication-provider)
		
3. [**Discovery Parameters**](#discovery-parameters)

    3.1. [User Message Capabilities](#user-message-capabilities)
    
    3.1.1. [User Message Supported](#user-message-supported)
    
    3.1.2. [User Message Supported MIME Types](#user-message-supported-mime-types)
    
    3.2. [Requested Authentication Provider Capabilities](#requested-authentication-provider-capabilities)

4. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

This specification defines authentication request parameter extensions for the Swedish OpenID
Connect Profile. These parameters are OPTIONAL to support for both Relying Parties and OpenID
Providers. The purpose of the request parameter extensions is to provide standardized solutions
to commonly identified use cases, but support for any of these extensions are not needed to be
compliant with the [The Swedish OpenID Connect Profile](#oidc-profile), 
\[[OIDC.Sweden.Profile](#oidc-profile)\].

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="conformance"></a>
### 1.2. Conformance

This profile defines requirements for OpenID Connect Relying Parties (clients) and OpenID Connect Providers (identity providers). Furthermore, it defines the interaction between a Relying Party and an OpenID Provider.

When a component compliant with this profile is interacting with other components compliant with this profile, all components MUST fully conform to the features and requirements of this specification. Any interaction with components that are not compliant with this profile is out of scope for this specification.

<a name="authentication-request-parameter-extensions"></a>
## 2. Authentication Request Parameter Extensions

This section defines authentication request parameters for some commonly identified use cases.
The identifiers for all authentication request parameter extensions defined in this specification
are prefixed with `https://id.oidc.se/param`.

<a name="client-provided-user-message"></a>
#### 2.1. Client Provided User Message

**Parameter:** `https://id.oidc.se/param/userMessage`

**Description:** When the user message claim is included in an authentication request, the issuing
client requests that the OpenID Provider displays this message to the client in conjunction with
the user authentication. 

**Value type:** The value for the user message request parameter claim is a JSON object<sup>1</sup>
 with the following fields:

* `message` - The base64-encoding of the UTF-8 string holding the message to display to the user.

* `mime_type` - The MIME type of the supplied message. This profile defines two possible values that
are `text/plain` (where `;charset=UTF-8` is an implicit condition) and `text/markdown`<sup>2</sup>.
If no value is given for this field, `text/plain` MUST be assumed. Other profiles MAY add support for
additional MIME types. 

A requesting entity MAY include several `message` fields for different languages. This is done
according to section 5.2 of \[[OpenID.Core](#openid-core)\], where a `#` sign is used to delimit
the member name (`message`) from the language tag (see \[[RFC5646](#rfc5646)\]). See the example below.

If the OpenID Provider has declared `ui_locales_supported` in its metadata (see section 3 of \[[OpenID.Discovery](#openid-discovery)\]) the client SHOULD restrict messages to the languages
declared by the OP.

**Requirements:** An OpenID Provider MUST NOT display a "user message" unless the user is being
authenticated. Thus, if the request contains the `prompt` parameter with the value `none` (see
section 2.1.4 of \[[OIDC.Sweden.Profile](#oidc-profile)\]), the OpenID Provider MUST NOT display
the user message.

This profile does not specify how the message should be displayed by the OpenID Provider, but if the
`display` request parameter (see 3.1.2.1 of \[[OpenID.Core](#openid-core)\]) is included in the request,
and supported by the OP, the provider SHOULD display the user message according to the value of the
`display` parameter.

The OpenID Provider MUST display the message matching the user interface locale that is in use. If no
message matches that current locale the OP MUST choose the message without a given language tag
if such a parameter is available. If no message parameter without a language tag is received, the OP MAY 
choose not to display any message, or select a message from the provided message parameters.

An OpenID Provider MUST refuse to display a message if it does not support a given MIME type.

Should a message contain illegal characters, or any other constructs not accepted by the provider,
the OP MAY choose not to display the message, or filter the message before displaying it.

**Example 1:** No language is specified.

```
...
"https://id.oidc.se/param/userMessage" : {  
  "message" : "<Base64-encoded message>",  (language is undefined)
  "mime_type" : "text/plain"
},
...
```

**Example 2:** Messages for different languages are specified.

```
...
"https://id.oidc.se/param/userMessage" : {  
  "message#sv" : "<Base64-encoded message in Swedish>",
  "message#en" : "<Base64-encoded message in English>",
  "mime_type" : "text/plain"
},
...
```

**\[1\]:** The `https://id.oidc.se/param/userMessage` parameter value is represented in an
authentication request as UTF-8 encoded JSON (which ends up being form-urlencoded when passed as a
parameter). When used in a Request Object value, per section 6.1 of \[[OpenID.Core](#openid-core)\],
the JSON is used as the value of the `https://id.oidc.se/param/userMessage` member.

**\[2\]:** The Markdown dialect, and potential restrictions for tags, is not regulated in this specification.

<a name="requested-authentication-provider"></a>
#### 2.2. Requested Authentication Provider

**Parameter:** `https://id.oidc.se/param/authnProvider`

**Description:** In cases where the OpenID Provider can delegate, or proxy, the user 
authentication to multiple authentication services, or if the OP offers multiple authentication
mechanisms, the `authnProvider` request parameter MAY be used to inform the OP about 
which of the authentication services, or mechanisms, that the Relying Party requests the user 
to be authenticated at/with.

An OpenID Provider that offers several different mechanisms for end-user
authentication normally displays a dialogue from where the user selects how to authenticate.
When the `authnProvider` request parameter is used, this interaction may be skipped.

How possible values for this request parameter is announced by the OpenID Provider is
out of scope for this specification. 

Section 2.3.5 of \[[OIDC.Sweden.Attr](#attr-spec)\] defines the claim 
`https://id.oidc.se/claim/authnProvider` that MAY be included in an ID token by an OpenID Provider.
The value of this claim can be used by the Relying Party to request re-authentication of an end-user.
By assigning the value to the `authnProvider` request parameter, the RP requests that the user is
authenticated using the same authentication mechanism that he or she originally was authenticated with.

**Value type:** String, preferably an URI

<a name="discovery-parameters"></a>
## 3. Discovery Parameters

This section defines OpenID Connect discovery identifiers that are used to announce support
for the authentication request parameters defined in this specification. All these identifiers
are prefixed with `https://id.oidc.se/disco`.

An OpenID Provider supporting any of the authentication request parameters defined in 
[section 2](#authentication-request-parameter-extensions) MUST include the corresponding
discovery parameter value, defined below, in its discovery document.

<a name="user-message-capabilities"></a>
### 3.1. User Message Capabilities

This profile defines two OpenID Discovery parameters that may be used by OpenID Providers to announce support for 
the `https://id.oidc.se/param/userMessage` authentication request parameter, see section 
[2.1](#client-provided-user-message), [Client Provided User Message](#client-provided-user-message), above.

<a name="user-message-supported"></a>
#### 3.1.1. User Message Supported

**Parameter:** `https://id.oidc.se/disco/userMessageSupported`

**Description:** A discovery parameter specifying whether the OpenID Provider supports the 
`https://id.oidc.se/param/userMessage` authentication request parameter, see section 
[2.1](#client-provided-user-message), [Client Provided User Message](#client-provided-user-message),
above.

**Value type:** Boolean

<a name="user-message-supported-mime-types"></a>
#### 3.1.2. User Message Supported MIME Types

**Parameter:** `https://id.oidc.se/disco/userMessageSupportedMimeTypes`

**Description:** Holds the User Message MIME type(s) that is supported by the OpenID Provider.
Its value is only relevant if `https://id.oidc.se/disco/userMessageSupported` is set to `true`
(see above). 

If this parameter is not set by the OP, a default of `[ "text/plain" ]` MUST be assumed.

**Value type:** A JSON array of strings 

<a name="requested-authentication-provider-capabilities"></a>
### 3.2. Requested Authentication Provider Capabilities

**Parameter:** `https://id.oidc.se/disco/authnProviderSupported`

**Description:** A discovery parameter specifying whether the OpenID Provider supports the
`https://id.oidc.se/param/authnProvider` authentication request parameter, see section
[2.2](#requested-authentication-provider), 
[Requested Authentication Provider](#requested-authentication-provider).

**Value type:** Boolean

<a name="normative-references"></a>
## 4. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="openid-discovery"></a>
**\[OpenID.Discovery\]**
> [Sakimura, N., Bradley, J., Jones, M. and E. Jay, "OpenID Connect Discovery 1.0", August 2015](https://openid.net/specs/openid-connect-discovery-1_0.html).

<a name="rfc5646"></a>
**\[RFC5646\]**
> [Phillips, A. and M. Davis, “Tags for Identifying Languages,” BCP 47, RFC 5646, September 2009](https://www.rfc-editor.org/rfc/rfc5646).

<a name="attr-spec"></a>
**\[OIDC.Sweden.Attr\]**
> [Attribute Specification for the Swedish OpenID Connect Profile](https://www.oidc.se/specifications/swedish-oidc-attribute-specification.html).

<a name="oidc-profile"></a>
**\[OIDC.Sweden.Profile\]**
> [The Swedish OpenID Connect Profile](https://www.oidc.se/specifications/swedish-oidc-profile.html).
