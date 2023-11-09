![Logo](img/oidc-logo.png)

# Claims and Scopes Specification for the Swedish OpenID Connect Profile

### Version: 1.0 - draft 04 - 2023-11-09

## Abstract

This specification defines claims and scopes for the Swedish OpenID Connect profile.


## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

2. [**Claims**](#claims)

    2.1. [User Identity Claims](#user-identity-claims)
    
    2.1.1. [Swedish Personal Identity Number](#swedish-personal-identity-number)
    
    2.1.2. [Swedish Coordination Number](#swedish-coordination-number)
    
    2.2. [Organizational Identity Claims](#organizational-identity-claims)
    
    2.2.1. [Swedish Organization Number](#swedish-organization-number)
    
    2.2.2. [Swedish Organizational Affiliation](#swedish-organizational-affiliation)
    
    2.2.3. [Organization Name](#organization-name)
    
    2.2.4. [Organizational Unit Name](#organizational-unit-name)
    
    2.3. [Authentication Information Claims](#authentication-information-claims)
    
    2.3.1. [User Certificate](#user-certificate)
    
    2.3.2. [User Signature](#user-signature)
    
    2.3.3. [User Credentials Validity](#user-credentials-validity)
    
    2.3.4. [Authentication Evidence](#authentication-evidence)

    2.3.5. [Authentication Provider](#authentication-provider)
    
    2.4. [General Purpose Claims](#general-purpose-claims)

    2.4.1. [Country](#country)
    
    2.4.2. [Birth Name](#birth-name)
    
    2.4.3. [Place of Birth](#place-of-birth)

    2.4.4. [Age](#age) 
3. [**Scopes**](#scopes)

    3.1. [Natural Person Information](#natural-person-information)
    
    3.2. [Natural Person Identity - Personal Number](#natural-person-identity-personal-number)
        
    3.3. [Natural Person Organizational Identity](#natural-person-organizational-identitys

4. [**Normative References**](#normative-references)

<a name="introduction"></a>
## 1. Introduction

This specification aims to provide definitions of a common set of claims (attributes) that
primarily is be used by Swedish OpenID Connect providers and clients, but can also be used
in a pure OAuth2 context. The goal is to facilitate interoperability by supplying definitions
for claims that are commonly used independently of the sector of operation.

Special purpose claims, such as healthcare specific claims, are not covered by this
specification. However, this specification may serve as the base line for more sector specific
specifications, and in that way ensure that common claims do not have several different
representations (as is the case for the different SAML attribute specifications in use today).

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="claims"></a>
## 2. Claims

This specification defines a set of claims that extend the set of standard claims defined in \[[RFC7515](#rfc7515)\] and 
section 5.1 of \[[OpenID.Core](#openid-core)\]. A full listing of standard claims can be found in the [IANA JSON Web Token Claims
Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims), \[[IANA-Reg](#iana-reg)\].

The claims and scopes defined in this specification are named in a collision-resistant manner, as described in JSON Web Token (JWT),
\[[RFC7515](#rfc7515)\], specification. All claims and scopes defined within this specification are prefixed with the namespaces 
`https://id.oidc.se/claim/` and `https://id.oidc.se/scope/` respectively.

<a name="user-identity-claims"></a>
### 2.1. User Identity Claims

<a name="swedish-personal-identity-number"></a>
#### 2.1.1. Swedish Personal Identity Number

**Claim:** `https://id.oidc.se/claim/personalIdentityNumber`

**Description:** Swedish civic registration number (”personnummer”) according to \[[SKV704](#skv704)\].

**Type:** String where the format is 12 digits without hyphen.

<a name="swedish-coordination-number"></a>
#### 2.1.2. Swedish Coordination Number

**Claim:** `https://id.oidc.se/claim/coordinationNumber`

**Description:** Swedish coordination number (”samordningsnummer”) according to \[[SKV707](#skv707)\].

**Type:** String where the format is 12 digits without hyphen.

> **Note (i):** See section [2.1.2.1](#coordination-number-level), [Coordination Number Level](#coordination-number-level),
below for a claim definition that represents a coordination number level. This claim MAY be used in conjunction with
the `coordinationNumber` claim.

> **Note (ii):** A Swedish coordination number also has a "status" associated. This status can be active, on hold or
> deregistered. This profile's definition of the `https://id.oidc.se/claim/coordinationNumber` claim does not
> put any requirements regarding the number's status. However, this can be made when the claim is part of a scope,
> see section [3.2](#natural-person-identity-personal-number), [Natural Person Identity - Personal Number](#natural-person-identity-personal-number) below.

<a name="coordination-number-level"></a>
##### 2.1.2.1. Coordination Number Level

**Claim:** `https://id.oidc.se/claim/coordinationNumberLevel`

**Description:** According to \[[2021/22:276](#2021-22-276)\] a Swedish coordination number is classified with a "level"
that tells how well the holder has proven his or her identity in conjunction with the issuance of the number. Possible levels are:

- `confirmed` - The identity of the holder is fully confirmed.
- `probable` - The identity of the holder is probable, but not fully confirmed.
- `uncertain` - The identity of the holder is uncertain.

The `coordinationNumberLevel` claim may be used to represent this level when a coordination number is released.

**Type:** String holding any of the three values listed above.

> **Note (i):** \[[2021/22:276](#2021-22-276)\] is a government proposition that has been approved by the Swedish parliament
and it will lead to a law update concerning the handling of coordination numbers.

> **Note (ii):** The level of an assigned coordination number may changed over the lifetime of the number. For example, the
level (trustworthiness) may be increased after a supplementary identification, or the level may be lowered after an audit
where the original identification process was proved to be inadequate. This profile does not put any specific requirements
on the issuer of this claim, for example that the current coordination number status must be checked before each time it is
issued. This may be done by other profiles building upon this profile, but using the claim in the context of this profile
alone implies that the consuming entity MUST ensure that status of the coordination number before it is used.

<a name="previous-coordination-number"></a>
##### 2.1.2.2. Previous Coordination Number

**Claim:** `https://id.oidc.se/claim/previousCoordinationNumber`

**Description:**  All individuals born in Sweden or moving to Sweden with the intention of staying one year or longer will be
assigned a personal identity number ("personnummer") and registered in the population register. Prior to being assigned a 
Swedish personal identity number ("personnummer"), a coordination number (see [2.1.2](#swedish-coordination-number)) may be
issued in order to enable communication with various government authorities, healthcare institutions, higher education and banks.

In most cases regarding people that move to Sweden, a person first holds a coordination number during a period before he or she
is assigned a personal identity number. A typical use case is a person that seeks asylum and later is given a residence permit.
In this case the person may first hold a coordination number and if a residence permit is given a personal identity number will
be assigned.

For a service provider this may lead to problems since the primary identifier for an individual has changed. A login with the newly
assigned identifier will not match the user account previously used by this individual.

Therefore, this profile defines the `previousCoordinationNumber` claim to enable matching a previously held identity number to a
newly assigned identity number. The `previousCoordinationNumber` claim is typically released together with the "new" 
`personalIdentityNumber` claim in order to facilitate account matching at a service provider.

**Type:** See [2.1.1](#swedish-personal-identity-number) and [2.1.2](#swedish-coordination-number) above.

> **Note (i):** This claim is a special-purpose claim that most likely only will be used in very specific use cases. 
Therefore it is not included in any scope definitions below. A service provider wishing to potentially receive this claim
SHOULD request is explicitly using the `claims` request parameter.

> **Note (ii):** This profile does not put any requirements regarding the "status" associated with the coordination number
represented. Since it has been superseded by a Swedish personal identity number ("personnummer") its status may be non-active.

<a name="organizational-identity-claims"></a>
### 2.2. Organizational Identity Claims

This section defines a number of claims in the area of organizational identities. More specific claims concerning organizational belonging can be defined as an extension to this specification. 

<a name="swedish-organization-number"></a>
#### 2.2.1. Swedish Organization Number

**Claim:** `https://id.oidc.se/claim/orgNumber`

**Description:** Swedish organizational number ("organisationsnummer") according to \[[SKV709](#skv709)\].

**Type:** String where the format is 10 digits without hyphen.

<a name="swedish-organizational-affiliation"></a>
#### 2.2.2. Swedish Organizational Affiliation

**Claim:** `https://id.oidc.se/claim/orgAffiliation`

**Description:** The personal identity at a Swedish organization (identified as a Swedish organizational number according to 
\[[SKV709](#skv709)\]). The `orgAffiliation` claim is intended to be used as a primary identity claim for global personal
organizational identities. It consists of a personal identifier and an organizational identifier code (`orgNumber`).

This specification does not impose any specific requirements concerning the personal identifier part of the claim other than that
it MUST be unique for the given organization.

**Type:** String on the format \<personal-id\>@\<org-number\> where the personal-id part determined by the organization and the org-number part is according to [2.2.1](#swedish-organization-number) above.

> **Note (i)**: In the general case, a claims consumer MUST NOT assume a particular format or meaning of the personal identifier
part since different organizations may use different formats. A claims consumer should also be aware that a personal identifier
separated from its organizational identifier code can not be regarded as unique.

> **Note (ii)**: In the description above we write "global personal organizational identities". With global we refer to
an identity that is used outside of the issuing organization's scope/domain. The individual's identity within the organization
may be the, but is not required to be, the "personal-id" part of the claim.  

<a name="organization-name"></a>
#### 2.2.3. Organization Name

**Claim:** `https://id.oidc.se/claim/orgName`

**Description:** Registered organization name.

**Type:** String

<a name="organizational-unit-name"></a>
#### 2.2.4. Organizational Unit Name

**Claim:** `https://id.oidc.se/claim/orgUnit`

**Description:** Organizational unit name.

**Type:** String

<a name="authentication-information-claims"></a>
### 2.3. Authentication Information Claims

An "authentication information" claim delivers information about a specific authentication event.
An identity provider SHOULD deliver these kinds of claims in an ID token and not from the UserInfo
endpoint since the values the claims represent refers to an event, and not user properties as such. 

<a name="user-certificate"></a>
#### 2.3.1. User Certificate

**Claim:** `https://id.oidc.se/claim/userCertificate`

**Description:** An X.509 certificate presented by the subject (user) during the authentication process.

**Type:** String (Base64 encoded)

<a name="user-signature"></a>
#### 2.3.2. User Signature

**Claim:** `https://id.oidc.se/claim/userSignature`

**Description:** A signature that was produced by the subject (user) during the authentication, or signature, process.

> Note: This specification does not state any requirements on the type of signature object that is stored as a claim value.

**Type:** String (Base64 encoded)

<a name="user-credentials-validity"></a>
#### 2.3.3. User Credentials Validity

A relying party may wish to get information about the user's credentials used during the authentication process to serve as input to its risk based monitoring system, or simply to inform the user about "your eID is about to expire" (even though it is more natural to have the OP doing this). This section defines the corresponding claims to attributes and properties that are in use today in Swedish eID solutions.

<a name="credential-valid-from"></a>
##### 2.3.3.1. Credential Valid From

**Claim:** `https://id.oidc.se/claim/credentialValidFrom`

**Description:** The start time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="credential-valid-to"></a>
##### 2.3.3.2. Credential Valid To

**Claim:** `https://id.oidc.se/claim/credentialValidTo`

**Description:** The end time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="device-ip-address"></a>
##### 2.3.3.3. Device IP Address

**Claim:** `https://id.oidc.se/claim/deviceIp`

**Description:** If the user authenticated using an online device holding the user credentials (such as a mobile phone) this claim may be used to inform the relying party of the IP address of that device. 

> Note: This IP does not have to be the same as the User agent address (depending on the authentication scheme).

**Type:** String - An IPv4 or IPv6 address.

<a name="authentication-evidence"></a>
### 2.3.4. Authentication Evidence

**Claim:** `https://id.oidc.se/claim/authnEvidence`

**Description:** A generic claim that can be issued by an OpenID Provider to supply the client with proof,
or evidence, about the authentication process. It may be especially interesting for some clients if the
provider has delegated all, or parts, of the authentication process to another party. In such cases, the
claim can hold the encoding of an OCSP response, a SAML assertion, or even a signed JWT.

> Note: This specification does not further specify the contents of the claim.  

**Type:** String (Base64 encoded)

<a name="authentication-provider"></a>
### 2.3.5. Authentication Provider

**Claim:** `https://id.oidc.se/claim/authnProvider`

**Description:** A claim representing the identity of an "authentication provider"<sup>1</sup>. 
This claim is intended to be released by OpenID Providers that offers several authentication 
mechanisms (providers). This includes OpenID Providers that delegate, or proxy, the user authentication
to other services<sup>2</sup>. 

By including this claim in an ID token the OP informs the Relying Party about the identity of 
the provider (mechanism or authority) that authenticated the user.

**Type:** String, preferably an URI
 
> **\[1\]:** This maps to the "authenticating authority" from the 
[SAML v2.0 core specification](https://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf),
where the element `<saml2:AuthenticatingAuthority>` is defined for the same purpose as
we describe above. 

> **\[2\]:** These services, or authorities, do not necessarily have to be OpenID Providers, but 
can be SAML Identity Providers, or any other authentication service.

<a name="general-purpose-claims"></a>
### 2.4. General Purpose Claims

This section contains definitions of general purpose claims that do not fit into any of the above categories. 

<a name="country"></a>
#### 2.4.1. Country

**Claim:** `https://id.oidc.se/claim/country`

**Description:** \[[OpenID.Core](#openid-core)\] defines the `address` claim containing a `country` field, but
there are many other areas where a country needs to be represented other than in the context of an individual's
address. The `https://id.oidc.se/claim/country` claim is a general purpose claim that can be used to represent a country.

**Type:** String. ISO 3166-1 alpha-2 \[[ISO3166](#iso3166)\] two letter country code.

<a name="birth-name"></a>
#### 2.4.2. Birth Name

**Claim:** `https://id.oidc.se/claim/birthName`

**Description:** Claims that corresponds to the `name` claim defined in \[[OpenID.Core](#openid-core)\] but is the
full name at the time of birth for the subject.

**Type:** String

<a name="place-of-birth"></a>
#### 2.4.3. Place of Birth

**Claim:** `https://id.oidc.se/claim/placeOfbirth`

**Description:** Claim representing the place of birth for the subject. This specification does not define "place".
Depending on the context it may be "City" or "City, Country" or any other representation.

**Type:** String 

<a name="age"></a>
#### 2.4.4. Age

**Claim:** `https://id.oidc.se/claim/age`

**Description:** Claim representing the age (in years) of the subject person.

**Type:** Integer

<a name="scopes"></a>
## 3. Scopes

There are basically two ways for a Relying Party to indicate which claims it wishes to receive:

- By providing one, or more, scope values that maps to a set of claims.

- By explicitly requesting claims using the `claims` request parameter.

This specification defines a number of scopes that are useful within the context of Swedish
eID usage. 

Many Relying Parties that uses OpenID Connect to authenticate users can not solely depend
on the user's session at the OpenID Provider and the `sub` claim to log in the user to the
RP application. In the context of Swedish eID there are some obvious claims that are regarded
to be "primary" identity claims by Relying Parties, for example a Swedish personal identity
number. Such claims are needed by the Relying Party in order to log in a user to its application.
Therefore, this specification's scope definitions will define that some claims are to be delivered
in the ID token so that a Relying Party can fully log in a user without having to make a,
potentially, unnecessary call to the UserInfo endpoint.

For each scope defined below, a listing of the claims that the scope value requests (access to) is
declared. Each scope definition also presents a "claims parameter equivalent", i.e., how the
claims would be requested using the `claims` request parameter. This tells where claims should be
delivered (ID token and/or UserInfo endpoint), and whether the claims should be regarded as essential
or voluntary to deliver by the OP.

> Note that the use of "essential" does not imply that the OP must deliver the claim, only
that its delivery is marked as essential for the Relying Party's ability to continue the
specific task requested by the end-user (for example, logging the user in to the RP application,
or ensuring a smooth authorization for a specific task).

> If a scope definition states that a certain claim should be delivered in the ID token, its definition
will in many cases also include the same claim for delivery via the UserInfo endpoint. The reason for 
this is that the UserInfo endpoint should offer a complete set of user identity claims (based on 
the authorization of the RP).

**Note:** The scope definitions regarding the delivery location of claims assumes that authentication
requests are made using `response_type=code`. 

<a name="natural-person-information"></a>
### 3.1. Natural Person Information

**Scope:** `https://id.oidc.se/scope/naturalPersonInfo`

**Description:** A scope that defines a claim set that provides basic natural person information
normally associated with a Swedish eID.

| Requested Claims | Description/comment | Reference |
| :--- | :--- | :--- |
| `family_name` | Surname/family name | \[[OpenID.Core](#openid-core)\] |
| `given_name` | Given name | \[[OpenID.Core](#openid-core)\] |
| `middle_name` | Middle name | \[[OpenID.Core](#openid-core)\] |
| `name` | Display name | \[[OpenID.Core](#openid-core)\] |
| `birthdate` | Date of birth | \[[OpenID.Core](#openid-core)\] |

**Claims Parameter Equivalent:**

```
{
  "userinfo" : {
    "family_name" : null,
    "given_name" : null,
    "middle_name" : null,
    "name": null,
    "birthdate" : null
  }
}
```

**Note:**: The `https://id.oidc.se/scope/naturalPersonInfo` scope is a subset of the `profile` standard
scope as defined in section 5.4 of \[[OpenID.Core](#openid-core)\].

The `profile` scope is pretty much intended as a scope for an Internet user wishing to create an 
account on a website. Claims  such as `preferred_username`, `picture` and `website` indicates that.
Of course, not all claims within the scope need to be delivered, but for the sake of privacy a Relying Party should not ask for more claims than it actually requires. Therefore, this specification 
defines the `https://id.oidc.se/scope/naturalPersonInfo` scope to limit the amount of user identity
claims to what is offered using a Swedish eID.

<a name="natural-person-identity-personal-number"></a>
### 3.2. Natural Person Identity - Personal Number

**Scope:** `https://id.oidc.se/scope/naturalPersonNumber`

**Description:** A scope that requests a Swedish civic registration number (personnummer) or 
a Swedish coordination number (samordningsnummer). These identity numbers are often used as 
primary identities at public Swedish organizations.

Note that an OpenID Provider delivering claims according to this scope MUST NOT deliver both a
`personalIdentityNumber` and a `coordinationNumber` claim. These are mutually exclusive. However, 
a person that holds a civic registration number (personnummer) may previously have had a 
coordination number. This number may then be delivered using the `previousCoordinationNumber` 
claim (see section [2.1.2.2](#previous-coordination-number)). This claim has to be explicitly
requested using the `claims` request parameter and is not part of the `naturalPersonNumber` scope.

Section [2.1.2.1](#coordination-number-level) declares a claim for coordination number levels.
This claim is seen as an informational claim, and needs to be explicitly requested using the
`claims` request parameter. 

| Claim | Description/comment | Reference |
| :--- | :--- | :--- |
| `https://id.oidc.se/claim/`<br />`personalIdentityNumber` | Swedish civic registration number. | This profile |
| `https://id.oidc.se/claim/`<br />`coordinationNumber` | Swedish coordination number. | This profile |


**Claims Parameter Equivalent:**

```
{
  "userinfo" : {
    "https://id.oidc.se/claim/personalIdentityNumber" : { "essential" : true },
    "https://id.oidc.se/claim/coordinationNumber" : { "essential" : true }
  },
  "id_token" : {
    "https://id.oidc.se/claim/personalIdentityNumber" : { "essential" : true },
    "https://id.oidc.se/claim/coordinationNumber" : { "essential" : true }
  }
}
```

Since a Swedish personal identity number often is required to authenticate at a public
Swedish organization these claims are delivered in the ID token and are marked as essential.
The claims should also be delivered via the UserInfo endpoint.

<a name="natural-person-organizational-identity"></a>
### 3.3. Natural Person Organizational Identity

**Scope:** `https://id.oidc.se/scope/naturalPersonOrgId`

**Description:** The “Natural Person Organizational Identity” scope requests basic organizational
identity information claims about a person. The organizational identity does not necessarily imply
that the subject has any particular relationship with or standing within the organization, but 
rather that this identity has been issued/provided by that organization for any particular reason
(employee, customer, consultant, etc.).

| Claim | Description/comment | Reference |
| :--- | :--- | :--- |
| `name` | Display name. The claim MAY contain personal information such as the given name or surname, but it MAY also be used as an anonymized display name, for example, "Administrator 123". This is decided by the issuing organization. | \[[OpenID.Core](#openid-core)\] |
| `https://id.oidc.se/claim/`<br />`orgAffiliation` | Personal identifier and organizational number. | This profile |
| `https://id.oidc.se/claim/`<br />`orgName` | Organization name. | This profile | 
| `https://id.oidc.se/claim/`<br />`orgNumber` | Swedish organization number. This number can always be derived from the orgAffiliation claim, but for simplicity it is recommended that an attribute provider includes this claim. | This profile | 

**Claims Parameter Equivalent:**

```
  "userinfo" : {
    "name" : null,
    "https://id.oidc.se/claim/orgName" : null,
    "https://id.oidc.se/claim/orgNumber" : null,
    "https://id.oidc.se/claim/orgAffiliation" : { "essential" : true }
  },
  "id_token" : {
    "https://id.oidc.se/claim/orgAffiliation" : { "essential" : true }
  }
```

A Relying Party including the `https://id.oidc.se/scope/naturalPersonOrgId` scope most likely 
uses the `https://id.oidc.se/claim/orgAffiliation` claim as a primary ID attribute for its users.
Therefore this claim is delivered in the ID token and is marked as essential. 

<a name="normative-references"></a>
## 4. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="rfc7515"></a>
**\[RFC7515\]**
> [Jones, M., Bradley, J., and N. Sakimura, “JSON Web Token (JWT)”, May 2015](https://tools.ietf.org/html/rfc7515).

<a name="iana-reg"></a>
**\[IANA-Reg\]**
> [IANA JSON Web Token Claims Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims).

<a name="rfc8417"></a>
**\[RFC8417\]**
> [P. Hunt, M. Jones, W. Denniss, M. Ansari, "Security Event Token (SET)", July 2018](https://tools.ietf.org/html/rfc8417).

<a name="iso3166"></a>
**\[ISO3166\]**
> Codes for the representation of names of countries and their subdivisions Part 1: Country codes, ISO standard, ISO 3166-1.

<a name="skv704"></a>
**\[SKV704\]**
> [Skatteverket, SKV 704 Utgåva 8, Personnummer](https://docs.swedenconnect.se/technical-framework/mirror/skv/skv704-8.pdf).

<a name="skv707"></a>
**\[SKV707\]**
> [Skatteverket, SKV 707, Utgåva 2,
> Samordningsnummer](https://docs.swedenconnect.se/technical-framework/mirror/skv/skv707-2.pdf).

<a name="2021-22-276"></a>
**\[2021/22:276\]**
> [Stärkt system för samordningsnummer - Proposition 2021/22:276](https://www.riksdagen.se/sv/dokument-lagar/dokument/proposition/starkt-system-for-samordningsnummer_H903276).

<a name="skv709"></a>
**\[SKV709\]**
> [Skatteverket, SKV 709, Utgåva 8, Organisationsnummer](https://docs.swedenconnect.se/technical-framework/mirror/skv/skv709-8.pdf).
