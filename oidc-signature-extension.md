# Signature Extension for OpenID Connect 1.0 - draft 01

## Abstract

This specification defines an extension to OpenID Connect to facilitate the use cases where a Relying Party sends a "Signature Request" to an OpenID Provider. A signature request is an extension of an OpenID Connect authentication request where a `SignatureRequest` JWT is passed as a Request Object parameter.


## Table of Contents

1. [**Introduction**](#introduction)

2. [**Signature Request Object**](#signature-request-object)

3. [**Signature Response Data**](#signature-response-data)

4. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

TODO: 

- Describe different types of signature use cases; BankID/Freja and federated signing.


<a name="the-signature-request-object"></a>
## 2. The Signature Request Object

Example of a Request Object holding the sign request extension:

```
...
"https://claims.oidc.se/1.0/signRequest" : {
  "tbs_data" : "<Base64-encoded data>",
  "sign_message" : {
    "mime_type" : "application/markdown",
    "message" : "<Base64-encoding of UTF-8 string holding the sign message>",
    "require_consent" : true
  }
},
...
```

> \[[OpenID.iGov](#openid-igov)\] states that Request Object MUST be signed and optionally be encrypted. Since the sign request is part of the Request Object this parameter does not explicitly be signed/encrypted.

> The `tbs_data` should be optional since it will not be used in the federated signing case ...

> TODO: Handle the case of proxies. If a proxy OP receives a SignRequest it will forward this to another OP. In these cases we may require re-encryption/re-signing....

> TODO: We need a way to distinguish between the different signature "modes" (direct vs federated).

**To investigate:**

Section 6 in \[[OpenID.Core](#openid-core)\] states the following:

> When the request parameter is used, the OpenID Connect request parameter values contained in the JWT supersede those passed using the OAuth 2.0 request syntax. However, parameters MAY also be passed using the OAuth 2.0 request syntax even when a Request Object is used; this would typically be done to enable a cached, pre-signed (and possibly pre-encrypted) Request Object value to be used containing the fixed request parameters, while parameters that can vary with each request, such as state and nonce, are passed as OAuth 2.0 parameters.

If we add the sign request extension as a request object this would mean that we would lose the possibility to use pre-signed Request Objects. Is this a big problem and should we consider introducing a new parameter for the authentication request? 



<a name="signature-response-data"></a>
## 3. Signature Response Data

- `http://claims.oidc.se/userSignature`
- and additional claims ...

<a name="normative-references"></a>
## 4. Normative References

<a name="openid-core"></a>
**\[OpenID.Core\]**
> [Sakimura, N., Bradley, J., Jones, M., de Medeiros, B. and C. Mortimore, "OpenID Connect Core 1.0", August 2015](https://openid.net/specs/openid-connect-core-1_0.html).

<a name="openid-igov"></a>
**\[OpenID.iGov\]**
> [M. Varley, P. Grassi, "International Government Assurance Profile (iGov) for OpenID Connect 1.0", October 05, 2018](https://openid.net/specs/openid-igov-openid-connect-1_0.html).

<a name="rfc7515"></a>
**\[RFC7515\]**
> [Jones, M., Bradley, J., and N. Sakimura, “JSON Web Token (JWT)”, May 2015](https://tools.ietf.org/html/rfc7515).

<a name="sc-dssext"></a>
**\[SC.DssExt\]**
> [DSS Extension for Federated Central Signing Services - Version 1.3, 2020-01-17](https://docs.swedenconnect.se/technical-framework/latest/09_-_DSS_Extension_for_Federated_Signing_Services.html).

<a name="bankid-api"></a>
**\[BankID.API\]**
> [BankID Relying Party Guidelines - Version: 3.5, 2020-10-26](https://www.bankid.com/assets/bankid/rp/bankid-relying-party-guidelines-v3.5.pdf).

<a name="freja-api"></a>
**\[Freja.API\]**
> [Freja eID Relying Party Developers' Documentation](https://frejaeid.com/rest-api/Freja%20eID%20Relying%20Party%20Developers'%20Documentation.html).

