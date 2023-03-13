![Logo](docs/images/oidc-text-right.png)

# Attribute Specification for the Swedish OAuth2 and OpenID Connect Profiles 

### Version: 1.0 - draft 02 - 2023-03-08

## Abstract

This specification defines claims (attributes) and scopes for the Swedish OAuth2 and OpenID Connect profiles.


## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

2. [**Attributes and Claims**](#attributes-and-claims)

    2.1. [User Identity Claims](#user-identity-claims)
    
    2.1.1. [Swedish Personal Identity Number](#swedish-personal-identity-number)
    
    2.1.2. [Swedish Coordination Number](#swedish-coordination-number)
    
    2.1.3. [Previous Personal Identity Number](#previous-personal-identity-number)

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
    
    2.4. [General Purpose Claims](#general-purpose-claims)

    2.4.1. [Country](#country)
    
    2.4.2. [Birth Name](#birth-name)
    
    2.4.3. [Place of Birth](#place-of-birth)

    2.4.4. [Age](#age) 
3. [**Scopes**](#scopes)

    3.1. [Natural Person Name Information](#natural-person-name-information)
    
    3.2. [Natural Person Identity - Personal Number](#natural-person-identity-personal-number)
        
    3.3. [Natural Person Organizational Identity](#natural-person-organizational-identity)

    3.4. [Authentication Information](#authentication-information)

4. [**Mappings to Other Specifications**](#mappings-to-other-specifications)

    4.1. [Sweden Connect SAML Specifications](#sweden-connect-saml-specifications)
    
    4.2. [BankID](#bankid)
    
    4.3. [Freja eID](#freja-eid)

5. [**Normative References**](#normative-references)

<a name="introduction"></a>
## 1. Introduction

This specification aims to provide definitions of a common set of attributes (claims) that primarily is be used by Swedish OpenID Connect providers and clients, but can also be used in a pure OAuth2 context. The goal is to facilitate interoperability by supplying definitions for attributes that are commonly used independently of the sector of operation.

Special purpose attributes, such as  healthcare specific attributes, are not covered by this specification. However, this specification may serve as the base line for more sector specific attribute specifications, and in that way ensure that common attributes do not have several different representations (as is the case for the different SAML attribute specifications in use today).

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="attributes-and-claims"></a>
## 2. Attributes and Claims

This specification defines a set of claims that extend the set of standard claims defined in \[[RFC7515](#rfc7515)\] and section 5.1 of \[[OpenID.Core](#openid-core)\]. A full listing of standard claims can be found in the [IANA JSON Web Token Claims Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims), \[[IANA-Reg](#iana-reg)\].

The claims defined in this specification are named in a collision-resistant manner, as described in JSON Web Token (JWT), \[[RFC7515](#rfc7515)\], specification. All claims defined within this specification are prefixed with the namespace `https://claims.oidc.se`.

<a name="user-identity-claims"></a>
### 2.1. User Identity Claims

<a name="swedish-personal-identity-number"></a>
#### 2.1.1. Swedish Personal Identity Number

**Claim:** `https://claims.oidc.se/1.0/personalNumber`

**Description:** Swedish civic registration number (”personnummer”) according to \[[SKV704](#skv704)\].

**Type:** String where the format is 12 digits without hyphen.

<a name="swedish-coordination-number"></a>
#### 2.1.2. Swedish Coordination Number

**Claim:** `https://claims.oidc.se/1.0/coordinationNumber`

**Description:** Swedish coordination number (”samordningsnummer”) according to \[[SKV707](#skv707)\].

**Type:** String where the format is 12 digits without hyphen.

> **Note:** See section [2.1.2.1](#coordination-number-level), [Coordination Number Level](#coordination-number-level),
below for a claim definition that represents a coordination number level. This claim MAY be used in conjunction with
the `coordinationNumber` claim.

<a name="coordination-number-level"></a>
##### 2.1.2.1. Coordination Number Level

**Claim:** `https://claims.oidc.se/1.0/coordinationNumberLevel`

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

<a name="previous-personal-identity-number"></a>
#### 2.1.3. Previous Personal Identity Number

**Claim:** `https://claims.oidc.se/1.0/previousPersonalNumber`

**Description:** In most cases a Swedish individual's primary identity claim is the civic registration number (”personnummer”) as
defined in section [2.1.1](#swedish-personal-identity-number) above, or a coordination number as defined in section [2.1.2](#swedish-coordination-number).

All individuals born in Sweden or moving to Sweden with the intention of staying one year or longer will be assigned a personal 
identity number and registered in the population register. A coordination number (see [2.1.2](#swedish-coordination-number))
may be assigned to a person that is not registered, but has the need to communicate with various government authorities, healthcare
institutions, higher education and banks.

In some cases a person may hold a coordination number during a period before he or she is assigned a personal identity number.
A typical use case is a person that seeks asylum and later is given a residence permit. In this case the person may first hold
a coordination number and if a residence permit is given a personal identity number will be assigned.

For a service provider this may lead to problems since the primary identifier for an individual has changed. A login with the newly
assigned identifier will not match the user account previously used by this individual.

This profile defines the `previousPersonalNumber` claim to enable matching a previously held identity number to a newly assigned
identity number. The `previousPersonalNumber` attribute is typically released together with the "new" `personalNumber` claim 
in order to facilitate account matching at a service provider.

**Type:** See [2.1.1](#swedish-personal-identity-number) and [2.1.2](#swedish-coordination-number) above.

> **Note:** This claim is a special-purpose claim that most likely only will be used in very specific use cases. Therefore it is not
included in any scope definitions below. A service provider wishing to potentially receive this claim SHOULD request is explicitly 
using the `claims` request parameter.

<a name="organizational-identity-claims"></a>
### 2.2. Organizational Identity Claims

This section defines a number of claims in the area of organizational identities. More specific claims concerning organizational belonging can be defined as an extension to this specification. 

<a name="swedish-organization-number"></a>
#### 2.2.1. Swedish Organization Number

**Claim:** `https://claims.oidc.se/1.0/orgNumber`

**Description:** Swedish organizational number ("organisationsnummer") according to \[[SKV709](#skv709)\].

**Type:** String where the format is 10 digits without hyphen.

<a name="swedish-organizational-affiliation"></a>
#### 2.2.2. Swedish Organizational Affiliation

**Claim:** `https://claims.oidc.se/1.0/orgAffiliation`

**Description:** The personal identity at a Swedish organization (identified as a Swedish organizational number according to \[[SKV709](#skv709)\]).

**Type:** String on the format \<personal-id\>@\<org-number\> where the personal-id part determined by the organization and the org-number part is according to [2.2.1](#swedish-organization-number) above.

<a name="organization-name"></a>
#### 2.2.3. Organization Name

**Claim:** `https://claims.oidc.se/1.0/orgName`

**Description:** Registered organization name.

**Type:** String

<a name="organizational-unit-name"></a>
#### 2.2.4. Organizational Unit Name

**Claim:** `https://claims.oidc.se/1.0/orgUnit`

**Description:** Organizational unit name.

**Type:** String

<a name="authentication-information-claims"></a>
### 2.3. Authentication Information Claims

An "authentication information" claim delivers information about a specific authentication event. An identity provider SHOULD deliver these kinds of claims in an ID token and not from the UserInfo endpoint since the values the claims represent refers to an event, and not user properties as such. 

<a name="user-certificate"></a>
#### 2.3.1. User Certificate

**Claim:** `https://claims.oidc.se/1.0/userCertificate`

**Description:** An X.509 certificate presented by the subject (user) during the authentication process.

**Type:** String (Base64 encoded)

<a name="user-signature"></a>
#### 2.3.2. User Signature

**Claim:** `https://claims.oidc.se/1.0/userSignature`

**Description:** A signature that was produced by the subject (user) during the authentication, or signature, process.

> Note: This specification does not state any requirements on the type of signature object that is stored as a claim value.

**Type:** String (Base64 encoded)

<a name="user-credentials-validity"></a>
#### 2.3.3. User Credentials Validity

A relying party may wish to get information about the user's credentials used during the authentication process to serve as input to its risk based monitoring system, or simply to inform the user about "your eID is about to expire" (even though it is more natural to have the OP doing this). This section defines the corresponding claims to attributes and properties that are in use today in Swedish eID solutions.

<a name="credential-valid-from"></a>
##### 2.3.3.1. Credential Valid From

**Claim:** `https://claims.oidc.se/1.0/credentialValidFrom`

**Description:** The start time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="credential-valid-to"></a>
##### 2.3.3.2. Credential Valid To

**Claim:** `https://claims.oidc.se/1.0/credentialValidTo`

**Description:** The end time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="device-ip-address"></a>
##### 2.3.3.3. Device IP Address

**Claim:** `https://claims.oidc.se/1.0/deviceIp`

**Description:** If the user authenticated using an online device holding the user credentials (such as a mobile phone) this claim may be used to inform the relying party of the IP address of that device. 

> Note: This IP does not have to be the same as the User agent address (depending on the authentication scheme).

**Type:** String - An IPv4 or IPv6 address.

<a name="authentication-evidence"></a>
### 2.3.4. Authentication Evidence

**Claim:** `https://claims.oidc.se/1.0/authnEvidence`

**Description:** A generic claim that can be issued by an identity provider to supply the relying party with proof, or evidence, about the authentication process. It may be especially interesting for some relying parties in the identity provider has delegated all, or parts, of the authentication process to another party. In such cases, the claim can hold the encoding of an OCSP response, a SAML assertion, or even a signed JWT.

> Note: This specification does not further specify the contents of the claim.  

**Type:** String (Base64 encoded)

<a name="general-purpose-claims"></a>
### 2.4. General Purpose Claims

This section contains definitions of general purpose claims that do not fit into any of the above categories. 

<a name="country"></a>
#### 2.4.1. Country

**Claim:** `https://claims.oidc.se/1.0/country`

**Description:** \[[OpenID.Core](#openid-core)\] defines the `address` claim containing a `country` field, but there are many other areas where a country needs to be represented other than in the context of an individual's address. The `https://claims.oidc.se/1.0/country` claim is a general purpose claim that can be used to represent a country.

**Type:** String. ISO 3166-1 alpha-2 \[[ISO3166](#iso3166)\] two letter country code.

<a name="birth-name"></a>
#### 2.4.2. Birth Name

**Claim:** `https://claims.oidc.se/1.0/birthName`

**Description:** Claims that corresponds to the `name` claim defined in \[[OpenID.Core](#openid-core)\] but is the full name at the time of birth for the subject.

**Type:** String

<a name="place-of-birth"></a>
#### 2.4.3. Place of Birth

**Claim:** `https://claims.oidc.se/1.0/placeOfbirth`

**Description:** Claim representing the place of birth for the subject. This specification does not define "place". Depending on the context it may be "City" or "City, Country" or any other representation.

**Type:** String 

<a name="age"></a>
#### 2.4.4. Age

**Claim:** `https://claims.oidc.se/1.0/age`

**Description:** Claim representing the age (in years) of the subject person. 

**Type:** Integer

<a name="scopes"></a>
## 3. Scopes

There are basically two ways for a Relying Party to indicate which claims it wishes to receive:

- By providing one, or more, scope values that maps to a set of claims.

- By explicitly requesting claims using the `claims` request parameter.

The way of requesting claims by providing scope values is dependent on that there is a defined meaning to each scope.
This section defines a set of scopes where each named scope maps to a set of claims.

Section 5.4 of \[[OpenID.Core](#openid-core)\] defines a set of standard scope values including the `profile` scope that
maps to the end-user "profile". This information comprises of the claims: `name`, `family_name`, `given_name`, `middle_name`, `nickname`, `preferred_username`, `profile`, `picture`, `website`, `gender`, `birthdate`, `zoneinfo`, `locale`, and `updated_at`.

The `profile` scope is pretty much intended as a scope for an Internet user wishing to create an account on a website. Claims such as `preferred_username`, `picture` and `website` indicates that. Of course, not all claims within the scope need to be delivered, but it is more useful to define more fine grained scopes. Also, for the sake of privacy a relying party should not ask for more claims than it actually requires. Therefore, this specification defines a set of scopes that combines standard claims with the claims defined in this specification.

This specification specifically takes into consideration the Swedish eID solutions, and the attributes that are tied to a Swedish eID.

For each scope defined below a set of claims is declared. Each declared claim has an indicator telling whether it is Mandatory or Optional within the given scope. A profile specification extending this attribute specification MAY change a declared claim's requirement from Optional to Mandatory, but MUST NOT lower the requirements from Mandatory to Optional. In those cases the extending specification need to define a new scope. Also, a profile specification extending this attribute MAY declare new claims, but MUST NOT remove any claims from the scope definition.

<a name="natural-person-name-information"></a>
### 3.1. Natural Person Name Information

**Scope:** `https://scopes.oidc.se/1.0/naturalPersonName`

**Description:** A scope that defines a claim set that provides basic natural person information without revealing the civic registration number of the subject.

| Claim | Description/comment | Requirement |
| :--- | :--- | :--- |
| `family_name` | Surname/family name - \[[OpenID.Core](#openid-core)\]. | Mandatory |
| `given_name` | Given name - \[[OpenID.Core](#openid-core)\]. | Mandatory |
| `name` | Display name - \[[OpenID.Core](#openid-core)\]. | Mandatory |

<a name="natural-person-identity-personal-number"></a>
### 3.2. Natural Person Identity - Personal Number

**Scope:** `https://scopes.oidc.se/1.0/naturalPersonPnr`

**Description:** The scope extends the `https://scopes.oidc.se/1.0/naturalPersonName` scope with a Swedish civic registration number (personnummer).

| Claim | Description/comment | Requirement |
| :--- | :--- | :--- |
| `https://claims.oidc.se/1.0/`<br />`personalNumber` | Swedish civic registration number | Mandatory<sup>\*</sup> |
| `https://claims.oidc.se/1.0/`<br />`coordinationNumber` | Swedish coordination number | Mandatory<sup>\*</sup> |
| `family_name` | Surname/family name - \[[OpenID.Core](#openid-core)\]. | Mandatory |
| `given_name` | Given name - \[[OpenID.Core](#openid-core)\]. | Mandatory |
| `name` | Display name - \[[OpenID.Core](#openid-core)\]. | Mandatory | 
| `birthdate` | Date of birth - \[[OpenID.Core](#openid-core)\]. | Optional | 

> **\[\*\]**: A `personalNumber` OR `coordinationNumber` claim MUST be delivered, but not both.

<a name="natural-person-organizational-identity"></a>
### 3.3. Natural Person Organizational Identity

**Scope:** `https://scopes.oidc.se/1.0/naturalPersonOrgId`

**Description:** The “Natural Person Organizational Identity” scope provides basic organizational identity information about a person. The organizational identity does not necessarily imply that the subject has any particular relationship with or standing within the organization, but rather that this identity has been issued/provided by that organization for any particular reason (employee, customer, consultant, etc.).

| Claim | Description/comment | Requirement |
| :--- | :--- | :--- |
| `name` | Display name. The claim MAY contain personal information such as the given name or surname, but it MAY also be used as an anonymized display name, for example, "Administrator 123". This is decided by the issuing organization (\[[OpenID.Core](#openid-core)\]). | Mandatory |
| `https://claims.oidc.se/`<br />`1.0/orgAffiliation` | Personal identifier and organizational number. | Mandatory |
| `https://claims.oidc.se/`<br />`1.0/orgName` | Organization name. | Mandatory |
| `https://claims.oidc.se/`<br />`1.0/orgNumber` | Swedish organization number. This number can always be derived from the mandatory orgAffiliation claim, but for simplicitly it is recommended that an attribute provider includes this claim. | Optional, but recommended | 

<a name="authentication-information"></a>
### 3.4. Authentication Information

**Scope:** `https://scopes.oidc.se/1.0/authnInfo`

**Description:** A scope that is used to request claims that represents information from the authentication process and information about the subject's credentials used to authenticate. 

This specification declares all claims as optional. A profile specification extending this attribute specification MAY change requirements to Mandatory and declare additional claims.

| Claim | Description/comment | Requirement |
| :--- | :--- | :--- |
| `txn` | Transaction identifier for the operation. See \[[RFC8417](#rfc8417)\]. | Optional |
| `https://claims.oidc.se/`<br />`1.0/userCertificate` | The certificate presented by the user during the authentication process. | Optional |
| `https://claims.oidc.se/`<br />`1.0/credentialValidFrom` | The start time of the user credential's validity. | Optional |
| `https://claims.oidc.se/`<br />`1.0/credentialValidTo` | The end time of the user credential's validity. | Optional |
| `https://claims.oidc.se/`<br />`1.0/deviceIp` | IP address of user's device holding the credentials. | Optional | 

Note: The `https://claims.oidc.se/1.0/authnEvidence` (authentication evidence) claim is not declared in the scope and need to be requested explicitly if required. The reason for this is that few relying parties are likely to be interested in that kind of detailed authentication information.

<a name="mappings-to-other-specifications"></a>
## 4. Mappings to Other Specifications

During development of this specification it is useful to look at which types of attributes that are handled by different technologies in order to analyze the need of custom claims.

<a name="sweden-connect-saml-specifications"></a>
### 4.1. Sweden Connect SAML Specifications

The following table defines a mapping from the SAML attribute names defined in "Attribute Specification for the Swedish eID Framework", \[[SC.AttrSpec](#sc-attrspec)\], to their corresponding attribute/claim.

| Description | SAML attribute name<br>and abbreviation | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Surname | urn:oid:2.5.4.4 (sn) | `family_name`| \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). | 
| Given name | urn:oid:2.5.4.42 (givenName) | `given_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). | 
| Display (full) name | urn:oid:2.16.840.1.<br/>113730.3.1.241 (displayName) | `name` | \[[OpenID.Core](#openid-core)\] |   |
| Gender | urn:oid:1.3.6.1.5.5.7.9.3 (gender) | `gender` | \[[OpenID.Core](#openid-core)\] | \[OpenID.Core\] defines possible values to be `female` and `male`. \[[SC.AttrSpec](#sc-attrspec)\] defines the possible values to be `M`/`m`, `F`/`f` and `U`/`u` (for unspecified). |
| Swedish Personal Number | urn:oid:1.2.752.29.4.13 (personalIdentityNumber) | `https://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | \[[SC.AttrSpec](#sc-attrspec)\] also uses the same attribute for a Swedish coordination number. This specification defines this claim to be `https://claims.oidc.se/1.0/coordinationNumber`. |
| Date of birth | urn:oid:1.3.6.1.5.5.7.9.1 (dateOfBirth) | `birthdate` | \[[OpenID.Core](#openid-core)\] | The format (YYYY-MM-DD) is the same for both the dateOfBirth SAML-attribute and the `birthdate` claim. |
| Name at the time of birth | urn:oid:1.2.752.201.3.8 (birthName) | `https://claims.oidc.se/`<br />`1.0/birthName`` | This specification | |
| Street address | urn:oid:2.5.4.9 (street) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Post office box | urn:oid:2.5.4.18 (postOfficeBox) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. The `street_address` MAY include house number, street name, Post Office Box, and multi-line extended street address information.   |
| Postal code | urn:oid:2.5.4.17 (postalCode) | `address.postal_code` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Locality | urn:oid:2.5.4.7 (l) | `address.locality` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Country | urn:oid:2.5.4.6 (c) | `address.country` or<br />`https://claims.oidc.se/`<br />`1.0/country` | \[[OpenID.Core](#openid-core)\]<br />This specification | Depends on in which context country is to be represented. |
| Place of birth | urn:oid:1.3.6.1.5.5.7.9.2 (placeOfBirth) | `https://claims.oidc.se/`<br />`1.0/placeOfbirth` | This specification | |
| Country of citizenship | urn:oid:1.3.6.1.5.5.7.9.4 (countryOfCitizenship) | - | - | No mapping exists at this moment. |
| Country of Residence | urn:oid:1.3.6.1.5.5.7.9.5 (countryOfResidence) | - | - | No mapping exists at this moment. |
| Telephone number | urn:oid:2.5.4.20 (telephoneNumber) | `phone_number` | \[[OpenID.Core](#openid-core)\] | See also `phone_number_verified`. |
| Mobile number | urn:oid:0.9.2342.19200300.100.1.41 (mobile) | `phone_number` | \[[OpenID.Core](#openid-core)\] | No specific claim exists that make a difference between a landline phone and a mobile phone in \[[IANA-Reg](#iana-reg)\]. Is this necessary? |
| E-mail address | urn:oid:0.9.2342.19200300.100.1.3 (mail) | `email` | \[[OpenID.Core](#openid-core)\] | See also `email_verified`. |
| Organization name | urn:oid:2.5.4.10 (o) | `https://claims.oidc.se/`<br />`1.0/orgName` | This specification |  |
| Organizational unit name | urn:oid:2.5.4.11 (ou) | `https://claims.oidc.se/`<br />`1.0/orgUnit` | This specification | |
| Organizational identifier code | urn:oid:2.5.4.97 (organizationIdentifier) | `https://claims.oidc.se/`<br/>`1.0/orgNumber` | This specification | |
| Organizational Affiliation | urn:oid:1.2.752.201.3.1 (orgAffiliation) | `https://claims.oidc.se/`<br/>`1.0/orgAffiliation` | This specification | |
| Transaction identifier | urn:oid:1.2.752.201.3.2 (transactionIdentifier) | `txn` | \[[RFC8417](#rfc8417)\] |
| Authentication Context Parameters | urn:oid:1.2.752.201.3.3 (authContextParams) | - |  | This attribute will not be represented as a claim. However, some of the data that are normally put in this attribute are not claims of their own (credentialValidFrom, ...).|
| User certificate | urn:oid:1.2.752.201.3.10 (userCertificate) | `https://claims.oidc.se`<br />`/1.0/userCertificate` | This specification | |
| User signature | urn:oid:1.2.752.201.3.11 (userSignature) | `https://claims.oidc.se/`<br />`1.0/userSignature` | This specification | |
| Authentication server signature | urn:oid:1.2.752.201.3.13 (authServerSignature) | `https://claims.oidc.se/`<br />`1.0/authnEvidence` | This specification | |
| Signature activation data | urn:oid:1.2.752.201.3.12 (sad) | `https://claims.oidc.se`<br />`1.0/sad` | \[[SignExt](#signext)\] | |
| Sign message digest | urn:oid:1.2.752.201.3.14 (signMessageDigest) | `https://claims.oidc.se/`<br />`1.0/signMessageDigest` | \[[SignExt](#signext)\] | |
| Provisional identifier | urn:oid:1.2.752.201.3.4 (prid) | `https://claims.oidc.se/`<br />`1.0/eidas/prid` | This specification | eIDAS specific |
| Provisional identifier persistence indicator | urn:oid:1.2.752.201.3.5 (pridPersistence) | `https://claims.oidc.se/`<br />`1.0/eidas/pridPersistence` | This specification | eIDAS specific |
| Personal number binding URI | urn:oid:1.2.752.201.3.6 (personalIdentityNumberBinding) | `https://claims.oidc.se/1.0/`<br />`eidas/personalNumberBinding` | This specification | eIDAS specific |
| eIDAS uniqueness identifier | urn:oid:1.2.752.201.3.7 (eidasPersonIdentifier) | `https://claims.oidc.se/`<br />`1.0/eidas/personIdentifier` | This specification | eIDAS specific |
| eIDAS Natural Person Address | urn:oid:1.2.752.201.3.9 (eidasNaturalPersonAddress) | `address` | \[[OpenID.Core](#openid-core)\] | Mapping of the eIDAS CurrentAddress attribute. |
| HSA-ID | urn:oid:1.2.752.29.6.2.1 (employeeHsaId) | - | - | Sector specific attribute. Should be defined elsewhere. |


<a name="bankid"></a>
### 4.2. BankID

The following table defines a mapping from the attribute names defined in "BankID Relying Party Guidelines", \[[BankID.API](#bankid-api)\], to their corresponding attribute/claim.

| Description | BankID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `user.personalNumber` | `https://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | |
| Display (full) name | `user.name` | `name` | \[[OpenID.Core](#openid-core)\] | |
| Given name | `user.givenName` | `given_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Surname | `user.surname` | `family_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Device IP-address | `device.ipAddress` | `https://claims.oidc.se/`<br />`1.0/deviceIp` | This specification | |
| Certificate notBefore time | `cert.notBefore` | `https://claims.oidc.se/`<br/>`1.0/credentialValidFrom` | This specification | See also `https://claims.oidc.se/1.0/userSignature`. |
| Certificate notAfter time | `cert.notAfter` | `https://claims.oidc.se/`<br/>`1.0/credentialValidTo` | This specification | See also `https://claims.oidc.se/1.0/userSignature`. |
| The BankID signature | `signature` | `https://claims.oidc.se/`<br/>`1.0/userSignature` | This specification |  |
| BankID OCSP response | `ocspResponse` | `https://claims.oidc.se/`<br />`1.0/authnEvidence` | This specification | |

<a name="freja-eid"></a>
### 4.3. Freja eID

The following table defines a mapping from the attribute names defined in "Freja eID Relying Party Developers' Documentation", \[[Freja.API](#freja-api)\], to their corresponding attribute/claim.

| Description | Freja eID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `ssnuserinfo.ssn` | `https://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | Freja's way of delivering SSN attribute included information about the country (`ssnuserinfo.country=SE`). |
| Given name | `basicUserInfo.name` | `given_name` | \[[OpenID.Core](#openid-core)\] | TODO: Does Freja's `basicUserInfo.name` mean given name of full name? |
| Surname | `basicUserInfo.surname` | `family_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| E-mail address (primary) | `emailAddress` | `email` | \[[OpenID.Core](#openid-core)\] | See also `email_verified`. |
| All e-mail addresses | `allEmailAddresses` | TBD | - | TBD |
| Date of birth | `dateOfBirth` | `birthdate` | \[[OpenID.Core](#openid-core)\] | The format (YYY-MM-DD) is the same for both the dateOfBirth attribute and the `birthdate` claim. |
| Country | `addresses[0].country` | `address.country` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| City | `addresses[0].city` | `address.locality` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Postal code | `addresses[0].postCode` | `address.postal_code` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Street address(es) | `addresses[0].address1`<br/>`addresses[0].address2`<br/>`addresses[0].address3` | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. The `address.street_address` MAY contain multiple lines, separated by newlines. |
| Address valid from | `addresses[0].validFrom` | TBD | - | TBD |
| Type of address | `addresses[0].type` | TDB | - | TBD |
| Source of address information | `addresses[0].sourceType` | TBD | - | TBD |

<a name="normative-references"></a>
## 5. Normative References

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

<a name="signext"></a>
**\[SignExt\]**
> [Signature Extension for OpenID Connect](https://github.com/oidc-sweden/specifications/blob/main/oidc-signature-extension.md).

<a name="sc-attrspec"></a>
**\[SC.AttrSpec\]**
> [Attribute Specification for the Swedish eID Framework - Version 1.6, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/04_-_Attribute_Specification_for_the_Swedish_eID_Framework.html).

<a name="sc-constructedattr"></a>
**\[SC.ConstructedAttr\]**
> [eIDAS Constructed Attributes Specification for the Swedish eID Framework - Version 1.1, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/11_-_eIDAS_Constructed_Attributes_Specification_for_the_Swedish_eID_Framework.html).

<a name="bankid-api"></a>
**\[BankID.API\]**
> [BankID Relying Party Guidelines - Version: 3.5, 2020-10-26](https://www.bankid.com/assets/bankid/rp/bankid-relying-party-guidelines-v3.5.pdf).

<a name="freja-api"></a>
**\[Freja.API\]**
> [Freja eID Relying Party Developers' Documentation](https://frejaeid.com/rest-api/Freja%20eID%20Relying%20Party%20Developers'%20Documentation.html).

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
