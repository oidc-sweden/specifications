# Cookbook for using the Swedish OpenID Connect Profile

## Abstract

This is a non-normative document that illustrates the use of the Swedish OpenID Connect Profile by giving examples on messages sent between a Relying Party (RP) and a OpenID Provider (OP). 

## Table of Contents

1. [**Introduction**](#introduction)

2. [**Authentication**](#authentication)

3. [**Usage of the Signature Extension**](#usage-of-the-signature-extension)

4. [**Discovery**](#discovery)

5. [**Client Registration**](#client-registration)


6. [**References**](#references)

<a name="introduction"></a>
## 1. Introduction

TODO

<a name="authentication"></a>
## 2. Authentication

TODO: 

- A request in its simplest form

- A request where specific scopes are included

- Illustration of how we require the IdP to authenticate the user (even if the user already has an active session at the IdP). Corresponds to ForceAuth=true in SAML.

- Request where specific claims are requested.

- Request where the RP passes known values to the OP (for example the personal identity number)

- How to set a requested Vector-of-trust and how to process a received one ...

<a name="usage-of-the-signature-extension"></a>
## 3. Usage of the Signature Extension

Examples of how to request a signature using the SignatureExtension request object JWT.

<a name="discovery"></a>
## 4. Discovery

TODO

<a name="client-registration"></a>
## 5. Client Registration

TODO

<a name="normative-references"></a>
## 6. References

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="openid-igov"></a>
**\[OpenID.iGov\]**
> [M. Varley, P. Grassi, "International Government Assurance Profile (iGov) for OpenID Connect 1.0", October 05, 2018](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

<a name="rfc8485"></a>
**\[RFC8485\]**
> [Richer, J. and L. Johansson, "Vectors of Trust", RFC 8485, DOI 10.17487/RFC8485, October 2018](https://tools.ietf.org/html/rfc8485).



