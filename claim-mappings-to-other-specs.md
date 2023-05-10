![Logo](img/oidc-logo.png)

# How OpenID Connect Claims Map to other Specifications

This is a non-normative paper that lists the attributes/claims used in Swedish eID-systems, and states how they map to OpenID Connect claims (defined in our specification or elsewhere).

## 1. Sweden Connect SAML Specifications

The following table defines a mapping from the SAML attribute names defined in "Attribute Specification for the Swedish eID Framework", \[[SC.AttrSpec](#sc-attrspec)\], to their corresponding attribute/claim.

| Description | SAML attribute name<br>and abbreviation | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Surname | urn:oid:2.5.4.4 (sn) | `family_name`| \[[OpenID.Core](#openid-core)\] |  | 
| Given name | urn:oid:2.5.4.42 (givenName) | `given_name` | \[[OpenID.Core](#openid-core)\] |  | 
| Display (full) name | urn:oid:2.16.840.1.<br/>113730.3.1.241 (displayName) | `name` | \[[OpenID.Core](#openid-core)\] |   |
| Gender | urn:oid:1.3.6.1.5.5.7.9.3 (gender) | `gender` | \[[OpenID.Core](#openid-core)\] | \[OpenID.Core\] defines possible values to be `female` and `male`. \[[SC.AttrSpec](#sc-attrspec)\] defines the possible values to be `M`/`m`, `F`/`f` and `U`/`u` (for unspecified). |
| Swedish Personal Number | urn:oid:1.2.752.29.4.13 (personalIdentityNumber) | `https://id.oidc.se/claim/`<br/>`personalIdentityNumber` | \[[OIDC.Sweden](#oidc-sweden)\] | \[[SC.AttrSpec](#sc-attrspec)\] also uses the same attribute for a Swedish coordination number. \[[OIDC.Sweden](#oidc-sweden)\] defines this claim to be `https://id.oidc.se/claim/coordinationNumber`. |
| previousPersonal-<br/>IdentityNumber | urn:oid:1.2.752.201.3.15<br />(previousPersonalIdentityNumber) | `https://id.oidc.se/claim/`<br />`previousCoordinationNumber` | [[OIDC.Sweden](#oidc-sweden)\] | The OIDC-profile only handles coordination numbers. |
| Date of birth | urn:oid:1.3.6.1.5.5.7.9.1 (dateOfBirth) | `birthdate` | \[[OpenID.Core](#openid-core)\] | The format (YYYY-MM-DD) is the same for both the dateOfBirth SAML-attribute and the `birthdate` claim. |
| Name at the time of birth | urn:oid:1.2.752.201.3.8 (birthName) | `https://id.oidc.se/claim/`<br />`birthName` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Street address | urn:oid:2.5.4.9 (street) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Post office box | urn:oid:2.5.4.18 (postOfficeBox) | `address.street_address` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. The `street_address` MAY include house number, street name, Post Office Box, and multi-line extended street address information.   |
| Postal code | urn:oid:2.5.4.17 (postalCode) | `address.postal_code` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Locality | urn:oid:2.5.4.7 (l) | `address.locality` | \[[OpenID.Core](#openid-core)\] | Field of the `address` claim. |
| Country | urn:oid:2.5.4.6 (c) | `address.country` or<br />`https://id.oidc.se/claim/`<br />`country` | \[[OpenID.Core](#openid-core)\]<br />\[[OIDC.Sweden](#oidc-sweden)\] | Depends on in which context country is to be represented. |
| Place of birth | urn:oid:1.3.6.1.5.5.7.9.2 (placeOfBirth) | `https://id.oidc.se/claim/`<br />`placeOfbirth` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Country of citizenship | urn:oid:1.3.6.1.5.5.7.9.4 (countryOfCitizenship) | - | - | No mapping exists at this moment. |
| Country of Residence | urn:oid:1.3.6.1.5.5.7.9.5 (countryOfResidence) | - | - | No mapping exists at this moment. |
| Telephone number | urn:oid:2.5.4.20 (telephoneNumber) | `phone_number` | \[[OpenID.Core](#openid-core)\] | See also `phone_number_verified`. |
| Mobile number | urn:oid:0.9.2342.19200300.100.1.41 (mobile) | `phone_number` | \[[OpenID.Core](#openid-core)\] | No specific claim exists that make a difference between a landline phone and a mobile phone in \[[IANA-Reg](#iana-reg)\]. Is this necessary? |
| E-mail address | urn:oid:0.9.2342.19200300.100.1.3 (mail) | `email` | \[[OpenID.Core](#openid-core)\] | See also `email_verified`. |
| Organization name | urn:oid:2.5.4.10 (o) | `https://id.oidc.se/claim/`<br />`orgName` | \[[OIDC.Sweden](#oidc-sweden)\] |  |
| Organizational unit name | urn:oid:2.5.4.11 (ou) | `https://id.oidc.se/claim/`<br />`orgUnit` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Organizational identifier code | urn:oid:2.5.4.97 (organizationIdentifier) | `https://id.oidc.se/claim/`<br/>`orgNumber` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Organizational Affiliation | urn:oid:1.2.752.201.3.1 (orgAffiliation) | `https://id.oidc.se/claim/`<br/>`orgAffiliation` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Transaction identifier | urn:oid:1.2.752.201.3.2 (transactionIdentifier) | `txn` | \[[RFC8417](#rfc8417)\] |
| Authentication Context Parameters | urn:oid:1.2.752.201.3.3 (authContextParams) | - |  | This attribute will not be represented as a claim. However, some of the data that are normally put in this attribute are not claims of their own (credentialValidFrom, ...).|
| User certificate | urn:oid:1.2.752.201.3.10 (userCertificate) | `https://id.oidc.se/claim/`<br />`userCertificate` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| User signature | urn:oid:1.2.752.201.3.11 (userSignature) | `https://id.oidc.se/claim/`<br />`userSignature` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Authentication server signature | urn:oid:1.2.752.201.3.13 (authServerSignature) | `https://id.oidc.se/claim/`<br />`authnEvidence` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Signature activation data | urn:oid:1.2.752.201.3.12 (sad) | - | - | No mapping exists - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| Sign message digest | urn:oid:1.2.752.201.3.14 (signMessageDigest) | - | - | No mapping exists - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| Provisional identifier | urn:oid:1.2.752.201.3.4 (prid) | - | - | eIDAS specific - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| Provisional identifier persistence indicator | urn:oid:1.2.752.201.3.5 (pridPersistence) | - | - | eIDAS specific - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| Personal number binding URI | urn:oid:1.2.752.201.3.6 (personalIdentityNumberBinding) | - | - | eIDAS specific - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| eIDAS uniqueness identifier | urn:oid:1.2.752.201.3.7 (eidasPersonIdentifier) | - | - | eIDAS specific - Will have to be handled in Sweden Connect's OpenID Connect profiles. |
| eIDAS Natural Person Address | urn:oid:1.2.752.201.3.9 (eidasNaturalPersonAddress) | `address` | \[[OpenID.Core](#openid-core)\] | Mapping of the eIDAS CurrentAddress attribute. |
| HSA-ID | urn:oid:1.2.752.29.6.2.1 (employeeHsaId) | - | - | Sector specific attribute. Should be defined elsewhere. |

<a name="bankid"></a>
## 2. BankID

The following table defines a mapping from the attribute names defined in "BankID Relying Party Guidelines", \[[BankID.API](#bankid-api)\], to their corresponding attribute/claim.

| Description | BankID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `user.personalNumber` | `https://id.oidc.se/claim/`<br/>`personalIdentityNumber` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Display (full) name | `user.name` | `name` | \[[OpenID.Core](#openid-core)\] | |
| Given name | `user.givenName` | `given_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Surname | `user.surname` | `family_name` | \[[OpenID.Core](#openid-core)\] | May be more than one name (separated by blank). |
| Device IP-address | `device.ipAddress` | `https://id.oidc.se/claim/`<br />`deviceIp` | \[[OIDC.Sweden](#oidc-sweden)\] | |
| Certificate notBefore time | `cert.notBefore` | `https://id.oidc.se/claim/`<br/>`credentialValidFrom` | \[[OIDC.Sweden](#oidc-sweden)\] | See also `https://id.oidc.se/claim/userSignature`. |
| Certificate notAfter time | `cert.notAfter` | `https://id.oidc.se/claim/`<br/>`credentialValidTo` | \[[OIDC.Sweden](#oidc-sweden)\] | See also `https://id.oidc.se/claim/userSignature`. |
| The BankID signature | `signature` | `https://id.oidc.se/claim/`<br/>`userSignature` | \[[OIDC.Sweden](#oidc-sweden)\] |  |
| BankID OCSP response | `ocspResponse` | `https://id.oidc.se/claim/`<br />`authnEvidence` | \[[OIDC.Sweden](#oidc-sweden)\] | |

<a name="freja-eid"></a>
## 3. Freja eID

The following table defines a mapping from the attribute names defined in "Freja eID Relying Party Developers' Documentation", \[[Freja.API](#freja-api)\], to their corresponding attribute/claim.

| Description | Freja eID attribute | Claim | Defined in | Comment | 
| :--- | :--- | :--- | :--- | :--- |
| Swedish Personal Number | `ssnuserinfo.ssn` | `https://id.oidc.se/claim/`<br/>`personalIdentityNumber`<br />or<br />`https://id.oidc.se/claim/`<br/>`coordinationNumber` | \[[OIDC.Sweden](#oidc-sweden)\] | Freja's way of delivering SSN attribute included information about the country (`ssnuserinfo.country=SE`). |
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
## 4. References

<a name="oidc-sweden"></a>
**\[OIDC.Sweden\]**
> Attribute Specification for the Swedish OpenID Connect Profile.

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="iana-reg"></a>
**\[IANA-Reg\]**
> [IANA JSON Web Token Claims Registry](https://www.iana.org/assignments/jwt/jwt.xhtml#claims).

<a name="rfc8417"></a>
**\[RFC8417\]**
> [P. Hunt, M. Jones, W. Denniss, M. Ansari, "Security Event Token (SET)", July 2018](https://tools.ietf.org/html/rfc8417).

<a name="sc-attrspec"></a>
**\[SC.AttrSpec\]**
> [Attribute Specification for the Swedish eID Framework - Version 1.6, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/04_-_Attribute_Specification_for_the_Swedish_eID_Framework.html).

<a name="bankid-api"></a>
**\[BankID.API\]**
> [BankID Relying Party Guidelines](https://www.bankid.com/en/utvecklare/guider/teknisk-integrationsguide).

<a name="freja-api"></a>
**\[Freja.API\]**
> [Freja eID Relying Party Developers' Documentation](https://frejaeid.com/rest-api/Freja%20eID%20Relying%20Party%20Developers'%20Documentation.html).
