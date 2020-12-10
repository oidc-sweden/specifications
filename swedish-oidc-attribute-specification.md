# Attribute Specification for the Swedish OpenID Connect Profile 1.0 - draft 01

## Abstract

The OpenID Connect protocol defines an identity federation system that allows a relying party to request and receive authentication and profile information about an end user.

This specification defines attributes/claims and scopes for the Swedish OpenID Connect profile.


## Table of Contents

1. [**Introduction**](#introduction)

2. [**Attributes and Claims**](#attributes-and-claims)

    2.1. [User Identity Claims](#user-identity-claims)
    
    2.1.1. [Swedish Personal Identity Number](#swedish-personal-identity-number)
    
    2.1.2. [Swedish co-ordination number](#swedish-coordination-number)
    
    2.1.3. [HSA-ID](#hsa-id)

    2.1.4. [eIDAS Person Identity](#eidas-person-identity)
    
    2.2. [Organizational Identity Claims](#organizational-identity-claims)
    
    2.2.1. [Swedish Organization Number](#swedish-organization-number)
    
    2.2.2. [Swedish Organizational Affiliation](#swedish-organizational-affiliation)
    
    2.2.3. [Organization Name](#organization-name)
    
    2.2.4. [Organizational Unit Name](#organizational-unit-name)
    
    2.3. [Authentication Information Claims](#authentication-information-claims)
    
    2.3.1. [User Certificate](#user-certificate)
    
    2.3.2. [User Signature](#user-signature)
    
    2.4. [Request Object Claims](#request-object-claims)

3. [**Scopes**](#scopes)

4. [**Mappings to Other Specifications**](#mappings-to-other-specifications)

    4.1. [Sweden Connect SAML Specifications](#sweden-connect-saml-specifications)
    
    4.2. [BankID](#bankid)
    
    4.3. [Freja eID](#freja-eid)

5. [**Normative References**](#normative-references)

<a name="introduction"></a>
## 1. Introduction

TODO

<a name="attributes-and-claims"></a>
## 2. Attributes and Claims

This specification defines a set of claims that extend the set of standard claims defined in \[[RFC7515](#rfc7515)\] and section 5.1 of \[[OpenID.Core](#openid-core)\]. A full listing of standard claims can be found in the [IANA JSON Web Token Claims Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims), \[[IANA-Reg](#iana-reg)\].

The claims defined in this specification are named in a collision-resistant manner, as described in JSON Web Token (JWT), \[[RFC7515](#rfc7515)\], specification. All claims defined within this specification are prefixed with the namespace `http://claims.oidc.se`.

<a name="user-identity-claims"></a>
### 2.1. User Identity Claims

<a name="swedish-personal-identity-number"></a>
#### 2.1.1. Swedish Personal Identity Number

**Claim:** `http://claims.oidc.se/personalNumber`

**Description:** Swedish civic registration number (”personnummer”) according to \[[SKV704](#skv704)\].

**Type:** String where the format is 12 digits without hyphen.

<a name="swedish-coordination-number"></a>
#### 2.1.2. Swedish co-ordination number

**Claim:** `http://claims.oidc.se/coordinationNumber`

**Description:** Swedish co-ordination number (”samordningsnummer”) according to \[[SKV707](#skv707)\].

**Type:** String where the format is 12 digits without hyphen.

> **For discussion:** We may need to introduce some sort of "issuer" field. Not all coordination numbers are "trustworthy"...

<a name="hsa-id"></a>
#### 2.1.3. HSA-ID

**Claim:** `http://claims.oidc.se/hsaid`

**Description:** Person identifier used by Swedish health care organizations.

**Type:** String with a format according to \[[Sambi.AttrSpec](#sambi-attrspec)\].

<a name="eidas-person-identity"></a>
#### 2.1.4. eIDAS Person Identity

**Claim:** `http://claims.oidc.se/eidasPersonId`

**Description:** Unique identifier and persistence indicator for an authentication performed against the eIDAS Framework. See section 3.3.1 of \[[SC.AttrSpec](#sc-attrspec)\].

**Type:** JSON object holding the following fields:

- `prid` - \[string\] - The "provisional ID" as calculated by the Swedish eIDAS-node.
- `persistence` - \[string\] - The persistence class of the above identity where the possible values are "A", "B" and "C".
- `eidasPersonIdentifier` - \[string\] - The identifier as received from the foreign eIDAS proxy service. This identifier is used by the Swedish node when generating the `prid` value.

**Example:**

```
"http://claims.oidc.se/eidasId" : {
  "prid" : "DE:8976543432",
  "persistence": "A",
  "eidasPersonIdentifier" : "DE/SE/0008976543432"
},
...
```

<a name="organizational-identity-claims"></a>
### 2.2. Organizational Identity Claims

<a name="swedish-organization-number"></a>
#### 2.2.1. Swedish Organization Number

**Claim:** `http://claims.oidc.se/orgNumber`

**Description:** Swedish organizational number ("organisationsnummer") according to \[[SKV709](#skv709)\].

**Type:** String where the format is 10 digits without hyphen.

<a name="swedish-organizational-affiliation"></a>
#### 2.2.2. Swedish Organizational Affiliation

**Claim:** `http://claims.oidc.se/orgAffiliation`

**Description:** The personal identity at a Swedish organization (identified as a Swedish organizational number according to \[[SKV709](#skv709)\]).

**Type:** String on the format \<personal-id\>@\<org-number\> where the personal-id part determined by the organization and the org-number part is according to [2.2.1](#swedish-organization-number) above.

<a name="organization-name"></a>
#### 2.2.3. Organization Name

**Claim:** `http://claims.oidc.se/orgName`

**Description:** Registered organization name.

**Type:** String

<a name="organizational-unit-name"></a>
#### 2.2.4. Organizational Unit Name

**Claim:** `http://claims.oidc.se/orgUnit`

**Description:** Organizational Unit Name.

**Type:** String

<a name="authentication-information-claims"></a>
### 2.3. Authentication Information Claims

An "authentication information" claim delivers information about a specific authentication event. An identity provider SHOULD deliver these kinds of claims in an ID token and not from the UserInfo endpoint since the values the claims represent refers to an event, and not user properties as such. 

> TODO: Discuss and think about attributes that are tied to a specific authentication event, (BankID) signature, or the authServerSignature attribute within Sweden Connect.

<a name="user-certificate"></a>
#### 2.3.1. User Certificate

**Claim:** `http://claims.oidc.se/userCertificate`

**Description:** The X.509 certificate presented by the subject (user) during the authentication process.

**Type:** String (Base64 encoded)

> **For discussion:** Do we need to map other fields, such as notBefore and notAfter?

<a name="user-signature"></a>
#### 2.3.2. User Signature

**Claim:** `http://claims.oidc.se/userSignature`

**Description:** A signature that was produced by the subject (user) during the authentication process.

**Type:** String (Base64 encoded)

<a name="request-object-claims"></a>
### 2.4. Request Object Claims

> Specific claims that are sent in a Request Object (in a JWT for the `request` or `request_uri` parameters).

<a name="scopes"></a>
## 3. Scopes

There are basically two ways for a Relying Party to indicate which claims it wishes to receive:

- By providing one, or more, scope values that maps to a set of claims.

- By explicitly requesting claims using the `claims` request parameter.

The way of requesting claims by providing scope values is dependent on that there is a defined meaning to each scope.
This section defines a set of scopes where each named scope maps to a set of claims.

Section 5.4 of \[[OpenID.Core](#openid-core)\] defines a set of standard scope values including the `profile` scope that
maps to the end-user "profile". This information comprises of the claims: `name`, `family_name`, `given_name`, `middle_name`, `nickname`, `preferred_username`, `profile`, `picture`, `website`, `gender`, `birthdate`, `zoneinfo`, `locale`, and `updated_at`.

> For discussion: There is no point in trying to create scopes that also contains the user surname and family name. At the same time the `profile` scope delivers a little bit too much for most cases.

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
| Swedish Personal Number | urn:oid:1.2.752.29.4.13 (personalIdentityNumber) | `http://claims.oidc.se/`<br/>`personalNumber` | This specification | \[[SC.AttrSpec](#sc-attrspec)\] also uses the same attribute for a Swedish co-ordination number. This specification defines this claim to be `http://claims.oidc.se/coordinationNumber`. |
| Date of birth | urn:oid:1.3.6.1.5.5.7.9.1 (dateOfBirth) | `birthdate` | \[[OpenID.Core](#openid-core)\] | The format (YYY-MM-DD) is the same for both the dateOfBirth SAML-attribute and the `birthdate` claim. |
| Name at the time of birth | urn:oid:1.2.752.201.3.8 (birthName) | - | - | No mapping exists at this moment. |
| Street address | urn:oid:2.5.4.9 (street) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Post office box | urn:oid:2.5.4.18 (postOfficeBox) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. The `street_address` MAY include house number, street name, Post Office Box, and multi-line extended street address information.   |
| Postal code | urn:oid:2.5.4.17 (postalCode) | `address.postal_code` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Locality | urn:oid:2.5.4.7 (l) | `address.locality` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Country | urn:oid:2.5.4.6 (c) | `address.country` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Place of birth | urn:oid:1.3.6.1.5.5.7.9.2 (placeOfBirth) | - | - | No mapping exists at this moment. |
| Country of citizenship | urn:oid:1.3.6.1.5.5.7.9.4 (countryOfCitizenship) | - | - | No mapping exists at this moment. |
| Country of Residence | urn:oid:1.3.6.1.5.5.7.9.5 (countryOfResidence) | - | - | No mapping exists at this moment. |
| Telephone number | urn:oid:2.5.4.20 (telephoneNumber) | `phone_number` | \[[OpenID.Core](#openid-core)\] | See also `phone_number_verified`. |
| Mobile number | urn:oid:0.9.2342.19200300.100.1.41 (mobile) | `phone_number` | \[[OpenID.Core](#openid-core)\] | No specific claim exists that make a difference between a landline phone and a mobile phone in \[[IANA-Reg](#iana-reg)\]. Is this necessary? |
| E-mail address | urn:oid:0.9.2342.19200300.100.1.3 (mail) | `email` | \[[OpenID.Core](#openid-core)\] | See also `email_verified`. |
| Organization name | urn:oid:2.5.4.10 (o) | `http://claims.oidc.se/`<br />`orgName` | This specification |  |
| Organizational unit name | urn:oid:2.5.4.11 (ou) | `http://claims.oidc.se/`<br />`orgUnit` | This specification | |
| Organizational identifier code | urn:oid:2.5.4.97 (organizationIdentifier) | `http://claims.oidc.se/`<br/>`orgNumber` | This specification | |
| Organizational Affiliation | urn:oid:1.2.752.201.3.1 (orgAffiliation) | `http://claims.oidc.se/`<br/>`orgAffiliation` | This specification | |
| Transaction identifier | urn:oid:1.2.752.201.3.2 (transactionIdentifier) | `txn` | \[[RFC8417](#rfc8417)\] | |
| ... | ... | ... | ... | ...|

> TODO: map all

<a name="bankid"></a>
### 4.2. BankID

The following table defines a mapping from the attribute names defined in "BankID Relying Party Guidelines", \[[BankID.API](#bankid-api)\], to their corresponding attribute/claim.

| Description | BankID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `user.personalNumber` | `http://claims.oidc.se/`<br/>`personalNumber` | This specification | |
| Display (full) name | `user.name` | `name` | \[[OpenID.Core](#openid-core)\] | |
| Given name | `user.givenName` | `given_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Surname | `user.surname` | `family_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Device IP-address | `device.ipAddress` | TBD | - | TDB |
| Certificate notBefore time | `cert.notBefore` | TBD | - | See `http://claims.oidc.se/userSignature`. |
| Certificate notAfter time | `cert.notAfter` | TBD | - | See `http://claims.oidc.se/userSignature`. |
| The BankID signature | `signature` | `http://claims.oidc.se/`<br/>`userSignature` | This specification |  |
| BankID OCSP response | `ocspResponse` | TBD | - | TBD |

<a name="freja-eid"></a>
### 4.3. Freja eID

The following table defines a mapping from the attribute names defined in "Freja eID Relying Party Developers' Documentation", \[[Freja.API](#freja-api)\], to their corresponding attribute/claim.

| Description | Freja eID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `ssnuserinfo.ssn` | `http://claims.oidc.se/`<br/>`personalNumber` | This specification | Freja's way of delivering SSN attribute included information about the country (`ssnuserinfo.country=SE`). |
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

<a name="sc-attrspec"></a>
**\[SC.AttrSpec\]**
> [Attribute Specification for the Swedish eID Framework - Version 1.6, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/04_-_Attribute_Specification_for_the_Swedish_eID_Framework.html).

<a name="sambi-attrspec"></a>
**\[Sambi.AttrSpec\]**
> [Sambi Attributspecifikation, version 1.5](https://www.sambi.se/wordpress/wp-content/uploads/2019/05/Sambi_Attributspecifikation_1.5.pdf).

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

<a name="skv709"></a>
**\[SKV709\]**
> [Skatteverket, SKV 709, Utgåva 8, Organisationsnummer](https://docs.swedenconnect.se/technical-framework/mirror/skv/skv709-8.pdf).
