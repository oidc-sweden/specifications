# Attribute Specification for the Swedish OAuth2 and OpenID Connect Profiles 

### Version: 1.0 - draft 01 - 2021-02-23

## Abstract

This specification defines attributes/claims and scopes for the Swedish OAuth2 and OpenID Connect profiles.


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
    
    2.3.2. [User Credentials Validity](#user-credentials-validity)
    
    2.3.3. [Authentication Evidence](#authentication-evidence)
    
    2.3.4. [Signature Claims](#signature-claims)
    
    2.4. [Request Object Claims](#request-object-claims)

3. [**Scopes**](#scopes)

4. [**Mappings to Other Specifications**](#mappings-to-other-specifications)

    4.1. [Sweden Connect SAML Specifications](#sweden-connect-saml-specifications)
    
    4.2. [BankID](#bankid)
    
    4.3. [Freja eID](#freja-eid)

5. [**Normative References**](#normative-references)

<a name="introduction"></a>
## 1. Introduction

This specification aims to provide definitions of a common set of attributes (claims) that may be used by Swedish OAuth2 and OpenID Connect providers and clients. The goal is to facilitate interoperability by supplying definitions for attributes that are commonly used independently of the sector of operation.

Special purpose attributes, such as the healthcare specific attributes defined in \[[Sambi.AttrSpec](#sambi-attrspec)\], are not covered by this specification. However, this specification may serve as the base line for more sector specific attribute specifications, and in that way ensure that common attributes do not have several different representations (as is the case for the different SAML attribute specifications in use today).

<a name="attributes-and-claims"></a>
## 2. Attributes and Claims

This specification defines a set of claims that extend the set of standard claims defined in \[[RFC7515](#rfc7515)\] and section 5.1 of \[[OpenID.Core](#openid-core)\]. A full listing of standard claims can be found in the [IANA JSON Web Token Claims Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims), \[[IANA-Reg](#iana-reg)\].

The claims defined in this specification are named in a collision-resistant manner, as described in JSON Web Token (JWT), \[[RFC7515](#rfc7515)\], specification. All claims defined within this specification are prefixed with the namespace `http://claims.oidc.se`.

<a name="user-identity-claims"></a>
### 2.1. User Identity Claims

<a name="swedish-personal-identity-number"></a>
#### 2.1.1. Swedish Personal Identity Number

**Claim:** `http://claims.oidc.se/1.0/personalNumber`

**Description:** Swedish civic registration number (”personnummer”) according to \[[SKV704](#skv704)\].

**Type:** String where the format is 12 digits without hyphen.

<a name="swedish-coordination-number"></a>
#### 2.1.2. Swedish co-ordination number

**Claim:** `http://claims.oidc.se/1.0/coordinationNumber`

**Description:** Swedish coordination number (”samordningsnummer”) according to \[[SKV707](#skv707)\].

**Type:** String where the format is 12 digits without hyphen.

> **Note:** The processes concerning the issuance of coordination numbers is currently being reviewed (see [Omstart av systemet med samordningsnummer](https://www.regeringen.se/pressmeddelanden/2020/01/omstart-av-systemet-med-samordningsnummer/)). The coordination numbers that are in use today will probably need an accomplishing attribute informing about the issuer and how trustworthy the number is.

<a name="hsa-id"></a>
#### 2.1.3. HSA-ID

**Claim:** `http://claims.oidc.se/1.0/hsaid`

**Description:** Person identifier used by Swedish health care organizations.

**Type:** String with a format according to \[[Sambi.AttrSpec](#sambi-attrspec)\].

<a name="eidas-person-identity"></a>
#### 2.1.4. eIDAS Person Identity

When using the Swedish eIDAS node to obtain an identity from within the eIDAS federation a set of identity claims are received. 

The Swedish eIDAS-node enriches attribute statements received from a member state eIDAS node with the provisional ID (prid) and provisional ID persistence (pridPersistence) attributes in order to make it easier for Swedish relying parties to handle foreign identities in an uniform manner, see section 3.3.1 of \[[SC.AttrSpec](#sc-attrspec)\].

<a name="provisional-id"></a>
##### 2.1.4.1. Provisional ID

**Claim:** `http://claims.oidc.se/1.0/eidas/prid`

**Description:** The prid claim is designed to provide one common unique attribute of the user in a common format regardless of the composition of the original attributes received from the authenticating source. The prid value is not stored in any registry, but derived from the received attributes at each authentication instant according to defined algorithms specified in \[[SC.ConstructedAttr](#sc-constructedattr)\]. The algorithm ensures that each prid is unique for each authenticated entity, but does not ensure persistence. If the attributes received for an entity changes over time, the prid claim may also change dependent on the defined prid generation algorithm for that attribute source.

**Type:** String (format according to \[[SC.ConstructedAttr](#sc-constructedattr)\]).

<a name="provisional-id-persistence-indicator"></a>
##### 2.1.4.2. Provisional ID Persistence Indicator

**Claim:** `http://claims.oidc.se/1.0/eidas/pridPersistence`

**Description:** The pridPersistence claim provides an indication of the expected persistence over time for a present prid value. The value of this attribute is determined from the selected prid generation algorithm in combination with the attribute source. For example, a prid derived from a Norwegian eIDAS unique identifier has longer persistence expectancy than a prid derived from the same attribute from the UK or Germany. This attribute helps relying parties to apply different UI and service functions for users with different persistence expectancy. This may assist users with low persistence expectancy to regain control of their user account, should their prid change in the future.

**Type:** String with the possible values `A`, `B` or `C` (see \[[SC.ConstructedAttr](#sc-constructedattr)\]).

<a name="eidas-person-identifier"></a>
##### 2.1.4.3. eIDAS Person Identifier

**Claim:** `http://claims.oidc.se/1.0/eidas/personIdentifier`

**Description:** A mapping of the eIDAS PersonIdentifier SAML attribute. A Swedish relying party should use the prid and pridPersistence claims in order to identify a person that has been authenticated via the Swedish eIDAS node, but in some cases the actual eIDAS person identifier (received from the foreign eIDAS node) may be required. A typical case may be when the relying party needs to refer to the person in communication with a foreign peer.

**Type:** String

##### 2.1.4.4. Personal Identity Number Binding

**Claim:** `http://claims.oidc.se/1.0/eidas/personalNumberBinding`

**Description:** If the `http://claims.oidc.se/1.0/personalNumber` claim (a Swedish civic registration number) is delivered by the Swedish eIDAS node it means that the node was able to make a binding between a foreign ID and a Swedish personal number. The personalNumberBinding claim will then contain an URI that uniquely identifies the binding (i.e., the process under which the ID mapping was performed). See section 3.2.2 of \[[SC.AttrSpec](#sc-attrspec)\].

**Type:** An URI


<a name="organizational-identity-claims"></a>
### 2.2. Organizational Identity Claims

This section defines a number of claims in the area of organizational identities. More specific claims concerning organizational belonging can be defined as an extension to this specification. 

<a name="swedish-organization-number"></a>
#### 2.2.1. Swedish Organization Number

**Claim:** `http://claims.oidc.se/1.0/orgNumber`

**Description:** Swedish organizational number ("organisationsnummer") according to \[[SKV709](#skv709)\].

**Type:** String where the format is 10 digits without hyphen.

<a name="swedish-organizational-affiliation"></a>
#### 2.2.2. Swedish Organizational Affiliation

**Claim:** `http://claims.oidc.se/1.0/orgAffiliation`

**Description:** The personal identity at a Swedish organization (identified as a Swedish organizational number according to \[[SKV709](#skv709)\]).

**Type:** String on the format \<personal-id\>@\<org-number\> where the personal-id part determined by the organization and the org-number part is according to [2.2.1](#swedish-organization-number) above.

<a name="organization-name"></a>
#### 2.2.3. Organization Name

**Claim:** `http://claims.oidc.se/1.0/orgName`

**Description:** Registered organization name.

**Type:** String

<a name="organizational-unit-name"></a>
#### 2.2.4. Organizational Unit Name

**Claim:** `http://claims.oidc.se/1.0/orgUnit`

**Description:** Organizational unit name.

**Type:** String

<a name="authentication-information-claims"></a>
### 2.3. Authentication Information Claims

An "authentication information" claim delivers information about a specific authentication event. An identity provider SHOULD deliver these kinds of claims in an ID token and not from the UserInfo endpoint since the values the claims represent refers to an event, and not user properties as such. 

<a name="user-certificate"></a>
#### 2.3.1. User Certificate

**Claim:** `http://claims.oidc.se/1.0/userCertificate`

**Description:** An X.509 certificate presented by the subject (user) during the authentication process.

**Type:** String (Base64 encoded)

<a name="user-credentials-validity"></a>
#### 2.3.2. User Credentials Validity

A relying party may wish to get information about the user's credentials used during the authentication process to serve as input to its risk based monitoring system, or simply to inform the user about "your eID is about to expire" (even though it is more natural to have the OP doing this). This section defines the corresponding claims to attributes and properties that are in use today in Swedish eID solutions.

<a name="credential-valid-from"></a>
##### 2.3.2.1. Credential Valid From

**Claim:** `http://claims.oidc.se/1.0/credentialValidFrom`

**Description:** The start time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="credential-valid-to"></a>
##### 2.3.2.2. Credential Valid To

**Claim:** `http://claims.oidc.se/1.0/credentialValidTo`

**Description:** The end time of the user credential's validity. 

**Type:** Integer - seconds since epoch (1970-01-01)

<a name="device-ip-address"></a>
##### 2.3.2.3. Device IP Address

**Claim:** `http://claims.oidc.se/1.0/deviceIp`

**Description:** If the user authenticated using an online device holding the user credentials (such as a mobile phone) this claim may be used to inform the relying party of the IP address of that device. 

> Note: This IP does not have to be the same as the User agent address (depending on the authentication scheme).

**Type:** String - An IPv4 or IPv6 address.

<a name="authentication-evidence"></a>
### 2.3.3. Authentication Evidence

**Claim:** `http://claims.oidc.se/1.0/authnEvidence`

**Description:** A generic claim that can be issued by an identity provider to supply the relying party with proof, or evidence, about the authentication process. It may be especially interesting for some relying parties in the identity provider has delegated all, or parts, of the authentication process to another party. In such cases, the claim can hold the encoding of an OCSP response, a SAML assertion, or even a signed JWT.

> Note: This specification does not further specify the contents of the claim.  

**Type:** String (Base64 encoded)

<a name="signature-claims"></a>
### 2.3.4. Signature Claims

The [Signature Extension for OpenID Connect](#signext), \[[SignExt](#signext)\], specification is a part of the Swedish OpenID Connect profile and defines an extension that enables a relying party to request that the user signs some data (or authenticates for signature). This section defines the claims that may be delivered as a result of such a process. 

<a name="user-signature"></a>
##### 2.3.4.1. User Signature

**Claim:** `http://claims.oidc.se/1.0/userSignature`

**Description:** A signature that was produced by the subject (user) during the authentication, or signature, process.

> Note: This specification does not state any requirements on the type of signature object that is stored as a claim value.

**Type:** String (Base64 encoded)

##### 2.3.4.2. Signature Activation Data

**Claim:** `http://claims.oidc.se/1.0/sad`

**Description:** The sad attribute holds Signature Activation Data that is required by a signature service in order to service a signature request in accordance with CEN EN 419 241-2. See further the "Signature Activation Protocol for Federated Signing", \[[SC.SAP](#sc-sap)\], specification.

**Type:** String

##### 2.3.4.3. Sign Message Digest

**Claim:** `http://claims.oidc.se/1.0/signMessageDigest`

**Description:** The signMessageDigest claim is delivered as a proof that an identity provider displayed a sign message for the user and that the user actively confirmed acceptance of this sign message. See section 3.2.4 of \[[SC.AttrSpec](#sc-attrspec)\] for details.

> Note: For federated signing according to the Sweden Connect model only.

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
| Swedish Personal Number | urn:oid:1.2.752.29.4.13 (personalIdentityNumber) | `http://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | \[[SC.AttrSpec](#sc-attrspec)\] also uses the same attribute for a Swedish co-ordination number. This specification defines this claim to be `http://claims.oidc.se/1.0/coordinationNumber`. |
| Date of birth | urn:oid:1.3.6.1.5.5.7.9.1 (dateOfBirth) | `birthdate` | \[[OpenID.Core](#openid-core)\] | The format (YYYY-MM-DD) is the same for both the dateOfBirth SAML-attribute and the `birthdate` claim. |
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
| Organization name | urn:oid:2.5.4.10 (o) | `http://claims.oidc.se/`<br />`1.0/orgName` | This specification |  |
| Organizational unit name | urn:oid:2.5.4.11 (ou) | `http://claims.oidc.se/`<br />`1.0/orgUnit` | This specification | |
| Organizational identifier code | urn:oid:2.5.4.97 (organizationIdentifier) | `http://claims.oidc.se/`<br/>`1.0/orgNumber` | This specification | |
| Organizational Affiliation | urn:oid:1.2.752.201.3.1 (orgAffiliation) | `http://claims.oidc.se/`<br/>`1.0/orgAffiliation` | This specification | |
| Transaction identifier | urn:oid:1.2.752.201.3.2 (transactionIdentifier) | `txn` | \[[RFC8417](#rfc8417)\] |
| Authentication Context Parameters | urn:oid:1.2.752.201.3.3 (authContextParams) | - |  | This attribute will not be represented as a claim. However, some of the data that are normally put in this attribute are not claims of their own (credentialValidFrom, ...).|
| User certificate | urn:oid:1.2.752.201.3.10 (userCertificate) | `http://claims.oidc.se`<br />`/1.0/userCertificate` | This specification | |
| User signature | urn:oid:1.2.752.201.3.11 (userSignature) | `http://claims.oidc.se/`<br />`1.0/userSignature` | This specification | |
| Authentication server signature | urn:oid:1.2.752.201.3.13 (authServerSignature) | `http://claims.oidc.se/`<br />`1.0/authnEvidence` | This specification | |
| Signature activation data | urn:oid:1.2.752.201.3.12 (sad) | `http://claims.oidc.se`<br />`1.0/sad` | This specification | |
| Sign message digest | urn:oid:1.2.752.201.3.14 (signMessageDigest) | `http://claims.oidc.se/`<br />`1.0/signMessageDigest` | This specification | |
| Provisional identifier | urn:oid:1.2.752.201.3.4 (prid) | `http://claims.oidc.se/`<br />`1.0/eidas/prid` | This specification | eIDAS specific |
| Provisional identifier persistence indicator | urn:oid:1.2.752.201.3.5 (pridPersistence) | `http://claims.oidc.se/`<br />`1.0/eidas/pridPersistence` | This specification | eIDAS specific |
| Personal number binding URI | urn:oid:1.2.752.201.3.6 (personalIdentityNumberBinding) | `http://claims.oidc.se/1.0/`<br />`eidas/personalNumberBinding` | This specification | eIDAS specific |
| eIDAS uniqueness identifier | urn:oid:1.2.752.201.3.7 (eidasPersonIdentifier) | `http://claims.oidc.se/`<br />`1.0/eidas/personIdentifier` | This specification | eIDAS specific |
| eIDAS Natural Person Address | urn:oid:1.2.752.201.3.9 (eidasNaturalPersonAddress) | `address` | \[[OpenID.Core](#openid-core)\] | Mapping of the eIDAS CurrentAddress attribute. |
| HSA-ID | urn:oid:1.2.752.29.6.2.1 (employeeHsaId) | `http://claims.oidc.se/`<br />`1.0/hsaid` | This specification | See also [[Sambi.AttrSpec](#sambi-attrspec)\]. |


<a name="bankid"></a>
### 4.2. BankID

The following table defines a mapping from the attribute names defined in "BankID Relying Party Guidelines", \[[BankID.API](#bankid-api)\], to their corresponding attribute/claim.

| Description | BankID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `user.personalNumber` | `http://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | |
| Display (full) name | `user.name` | `name` | \[[OpenID.Core](#openid-core)\] | |
| Given name | `user.givenName` | `given_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Surname | `user.surname` | `family_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Device IP-address | `device.ipAddress` | `http://claims.oidc.se/`<br />`1.0/deviceIp` | This specification | |
| Certificate notBefore time | `cert.notBefore` | `http://claims.oidc.se/`<br/>`1.0/credentialValidFrom` | This specification | See also `http://claims.oidc.se/1.0/userSignature`. |
| Certificate notAfter time | `cert.notAfter` | `http://claims.oidc.se/`<br/>`1.0/credentialValidTo` | This specification | See also `http://claims.oidc.se/1.0/userSignature`. |
| The BankID signature | `signature` | `http://claims.oidc.se/`<br/>`1.0/userSignature` | This specification |  |
| BankID OCSP response | `ocspResponse` | `http://claims.oidc.se/`<br />`1.0/authnEvidence` | This specification | |

<a name="freja-eid"></a>
### 4.3. Freja eID

The following table defines a mapping from the attribute names defined in "Freja eID Relying Party Developers' Documentation", \[[Freja.API](#freja-api)\], to their corresponding attribute/claim.

| Description | Freja eID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `ssnuserinfo.ssn` | `http://claims.oidc.se/`<br/>`1.0/personalNumber` | This specification | Freja's way of delivering SSN attribute included information about the country (`ssnuserinfo.country=SE`). |
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

<a name="signext"></a>
**\[SignExt\]**
> [Signature Extension for OpenID Connect](https://github.com/oidc-sweden/specifications/blob/main/oidc-signature-extension.md).

<a name="sc-attrspec"></a>
**\[SC.AttrSpec\]**
> [Attribute Specification for the Swedish eID Framework - Version 1.6, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/04_-_Attribute_Specification_for_the_Swedish_eID_Framework.html).

<a name="sc-constructedattr"></a>
**\[SC.ConstructedAttr\]**
> [eIDAS Constructed Attributes Specification for the Swedish eID Framework - Version 1.1, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/11_-_eIDAS_Constructed_Attributes_Specification_for_the_Swedish_eID_Framework.html).

<a name="sc-sap"></a>
**\[SC.SAP\]**
[Signature Activation Protocol for Federated Signing - Version 1.1, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/13_-_Signature_Activation_Protocol.html).

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
