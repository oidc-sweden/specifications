# Vector of Trust Registry for the Swedish OpenID Connect Profile 1.0 - draft 01

## Abstract

Some text ...

## Table of Contents

1. [**Introduction**](#introduction)

2. [**Trustmark URL**](#trustmark-url)

3. [**Component Categories and Values**](#component-categories-and-values)

    3.1. [**P - Identity Proofing**](#p-identity-proofing)
    
    3.2. [**C - Primary Credential Usage**](#c-primary-credential-usage)
    
    3.3. [**M - Primary Credential Management**](#m-primary-credential-management)

    3.4. [**A - Assertion Presentation**](#a-assertion-presentation)
    
    3.4.1. [Aa - No Protection](#aa-no-protection)
    
    3.4.2. [Ab - Signed Assertion via User Agent](#ab-signed-assertion-via-user-agent)
    
    3.4.3. [Ac - Signed Assertion in Back Channel](#ac-signed-assertion-in-back-channel)
    
    3.4.4. [Ad - Assertion Encrypted with Relying Party's Key](#ad-assertion-encrypted-with-relying-partys-key)
    
    3.5. [**L - Assurance Certification of Credentials Issuer**](#l-assurance-certification-of-credentials-issuer)
    
    3.5.1. [L0 - No Certification](#l0-no-certification)
    
    3.5.2. [La - DIGG - Level of Assurance 3](#la-digg-level-of-assurance-3)
    
    3.6. [**I - Assurance Certification of Identity Provider**](#i-assurance-certification-of-identity-provider)

4. [**Normative References**](#normative-references)

<a name="introduction"></a>
## 1. Introduction

In systems using Authentication Context Class references (`AuthnContextClassRef` for SAML and `acr` for OpenID Connect) a level of assurance identifier is included in the assertion to inform the RP about the "strength" of the authentication and how strongly the RP may trust the issued assertion. The problem is that this identifier has to cover many aspects; ranging from identity proofing to how the identity assertion is compiled and delivered. Vectors-of-trust, \[[RFC8485](#rfc8485)\], aims to solve this dilemma by offering fine grained representations of each part that is normally covered by a scalar value.

This specification defines a set of component categories and associated values under a defined trustmark URL.

<a name="trustmark-url"></a>
## 2. Trustmark URL

The trustmark URL for this specification is `https://www.oidc.se/specifications/trust/1.0`. 

<a name="component-categories-and-values"></a>
## 3. Component Categories and Values

This section defines the vectors-of-trust component categories with the associated values. 

<a name="p-identity-proofing"></a>
### 3.1. P - Identity Proofing

**Specification document:** \[[RFC8485](#rfc8485)\]

**Description:** The identity proofing category defines how strongly the set of identity attributes have been verified and vetted.

> **For discussion:** The RFC8485 defines four levels; 0 for no proofing, 1 for self-asserted proofing, 2 for proofing in person or remotely using trusted mechanisms and, 3 where there is a binding between the IdP and the user (such as employment records). 

> In a Swedish context we could be a little more specific. For example, I'd like to suggest that we make a distinction of (2) and (3). For example "proofing made according to LoA 3 or higher" or something that connects to well defined ways of performing "grundidentifiering".

<a name="c-primary-credential-usage"></a>
### 3.2. C - Primary Credential Usage

**Specification document:** \[[RFC8485](#rfc8485)\]

**Description:** The primary credential usage category defines how strongly the user credential can be verified by the identity provider. In other words, how easily that credential could be spoofed or stolen.

> **For discussion:** 

> RFC8485 defines the following:

> C0:  No credential is used / anonymous public service
>
> Ca:  Simple session HTTP cookies (with nothing else)
>
> Cb:  Known device, such as those indicated through device posture or device management systems
>
> Cc:  Shared secret, such as a username and password combination
>
> Cd:  Cryptographic proof of key possession using shared key
>
> Ce:  Cryptographic proof of key possession using asymmetric key
>
> Cf:  Sealed hardware token / keys stored in a trusted platform module
>
> Cg:  Locally verified biometric
> 
> Would this be OK, or do we want to have something about mobile devices that doesn't really qualify as "sealed hardware tokens" but are stronger than "PKCS#12 file on disk".
>
> Also, we may want to include values that map "a PIN was entered", "FaceID was used", "TouchID was used". The Cg value, Locally verified biometric, refers to a scenario where the IdP used biometrics to authenticate the user. But if we want to have information about how the user "unlocked" his/hers key we don't have that info. Or do we simple need a new category for this?

<a name="m-primary-credential-management"></a>
### 3.3. M - Primary Credential Management

**Specification document:** \[[RFC8485](#rfc8485)\]

**Description:** The primary credential management category holds information about the expected lifecycle of the credential in use, including its binding, rotation, and revocation.

> **For discussion:**
>
> RFC8485 states:
>
> The primary credential management component of this vector definition
   represents distinct categories of management that MAY be considered
   separately or together in a single transaction.  Many trust framework
   deployments MAY use a single value for this component as a baseline
   for all transactions and thereby omit it.  Multiple distinct values
   from this category MAY be used in a single transaction.
>
>  Ma:  Self-asserted primary credentials (user chooses their own
        credentials and must rotate or revoke them manually) / no
        additional verification for primary credential issuance or
        rotation

>  Mb:  Remote issuance and rotation / use of backup recover credentials
        (such as email verification) / deletion on user request
>
>  Mc:  Full proofing required for each issuance and rotation /
        revocation on suspicious activity
        
> **Question**: Do we need this? If so, how should we map the category?


<a name="a-assertion-presentation"></a>
### 3.4. A - Assertion Presentation

**Specification document:** \[[RFC8485](#rfc8485)\]

**Description:** The assertion presentation category defines how the given identity assertion can be communicated across the network without information leaking to unintended parties and without spoofing.

Multiple distinct values from this category MAY be used in a single transaction. For example, for an assertion that is both signed and encrypted the values would be `Ac.Ad`.

**Note:** The values defined below are the same values as defined in section A.4 of \[[RFC8485](#rfc8485)\].

<a name="aa-no-protection"></a>
#### 3.4.1. Aa - No Protection

Unsigned bearer identifier (such as an HTTP session cookie in a web browser).

<a name="ab-signed-assertion-via-user-agent"></a>
#### 3.4.2. Ab - Signed Assertion via User Agent

Signed and verifiable assertion, passed through the user agent (web browser).

<a name="ac-signed-assertion-in-back-channel"></a>
#### 3.4.3. Ac - Signed Assertion in Back Channel

Signed and verifiable assertion, passed through a back channel.

<a name="ad-assertion-encrypted-with-relying-partys-key"></a>
#### 3.4.4. Ad - Assertion Encrypted with Relying Party's Key

Assertion encrypted using the Relying Party's key.

<a name="l-assurance-certification-of-credentials-issuer"></a>
### 3.5. L - Assurance Certification of Credentials Issuer

**Specification document:** This document

**Description:** The assurance certification of credentials issuer category represents the assurance certification of the issuer of the credentials that was used by the end user during an authentication process.

In systems relying on authentication context class references the assurance certification is normally represented using an URI identifier. The problem with using a scalar value is that this identifier then has to be valid for all aspects of the authentication process ranging from the identity proofing of the user to how the identity assertion is created and delivered. In real-life scenarios there may be cases where a non-certified identity provider delivers authentication services using a certified credentials issuer. In those cases the identity provider can not use the assurance identifier assigned to the credentials issuer in the assertion.

> **For discussion:** Credentials issuer may be a bad name. What we are aiming at here is that an IdP (non-certified) are delivering authentication services from a certified eID provider. For example, CGI has an IdP that offers BankID authentication. CGI is not certified, but BankID is.

> **TODO:** Include all possible assurance levels that is of interest for a Swedish RP. Will there be too many?

<a name="l0-no-certification"></a>
#### 3.5.1. L0 - No Certification

The credentials issuer has not been certified.

<a name="la-digg-level-of-assurance-3"></a>
#### 3.5.2. La - DIGG - Level of Assurance 3

The credentials issuer is certified according to the Swedish Agency for Digital Government's trust framework at level 3. 

> TODO: Include references and include the URI for LoA3.


<a name="i-assurance-certification-of-identity-provider"></a>
### 3.6. I - Assurance Certification of Identity Provider

**Specification document:** This document

**Description:** The assurance certification of identity provider category represents the assurance certification of the identity provider.

> **TODO:** Include all possible assurance levels that is of interest for a Swedish RP. Will there be too many? 


<a name="normative-references"></a>
## 4. Normative References

<a name="rfc8485"></a>
**\[RFC8485\]**
> [Richer, J. and L. Johansson, "Vectors of Trust", RFC 8485, DOI 10.17487/RFC8485, October 2018](https://tools.ietf.org/html/rfc8485).

<a name="openid-igov"></a>
**\[OpenID.iGov\]**
> [M. Varley, P. Grassi, "International Government Assurance Profile (iGov) for OpenID Connect 1.0", October 05, 2018](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

