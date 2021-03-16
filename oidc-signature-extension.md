# Signature Extension for OpenID Connect

### Version: 1.0 - draft 01 - 2021-03-15

## Abstract

This specification defines an extension to OpenID Connect to facilitate the use cases where a Relying Party sends a "Signature Request" to an OpenID Provider. A signature request is an extension of an OpenID Connect authentication request where a `SignatureRequest` JWT is passed as a Request Object parameter.


## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
2. [**Signature Models**](#signature-models)
    
    2.1. [Delegated Signing](#delegated-signing)
    
    2.2. [Federated Signing](#federated-signing)

2. [**Signature Request Object**](#signature-request-object)

3. [**Signature Response Data**](#signature-response-data)

4. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

This specification defines an extension to OpenID Connect to facilitate that a user digitally signs data provided by a Relying Party at the OpenID Provider.

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="signature-models"></a>
## 2. Signature Models

This specification supports two types of signature models, or use cases; *Delegated Signing* and *Federated Signing*. 

As we will see, an OpenID Provider that supports the Delegated Signing model will automatically also support the Federated Signing model, but an OpenID Provider that supports the Federated Signing model does not necessarily support the Delegated Signing model.

<a name="delegated-signing"></a>
#### 2.1. Delegated Signing

For the delegated signing model the Relying Party delegates the signing operation to the OpenID Provider by sending an authentication request with a sign extension. The flow below illustrates each step in for the delegated signing model.

![Delegated signing](img/delegated-signing.png)

1. The user wants to sign something at the Relying Party, for example a form, and clicks "Sign".

2. The Relying Party (client) initiates an "authentication for signature" by redirecting the user to the OpenID Provider along with an authentication request containing a sign extension (see chapter XX below).

3. During the "authentication for signature" the user actually performs a signature of the "to-be-signed" data that was supplied as an extension to the authentication request. In this step the OpenID Provider also displays a summary of what is being signed.

4. After a completed signature operation the user agent is redirected back to the client along with an authorization code.

5. Next, the client obtains an ID token that contains information about the signee along with the signed data.

6. Finally, the completed signature operation is acknowledged to the user.

The advantage with this use case is that it is simple and straightforward. The disadvantage is that only OpenID Providers that actually supports eID:s that support creating signatures can be used.


<a name="federated-signing"></a>
#### 2.2. Federated Signing

The federated signature model is defined within the [Swedish eID Framework](https://docs.swedenconnect.se/technical-framework) and comprises an additional role, the Signature Service.

A Signature Service is a stand-alone service that exposes a signature API to its relying parties. Within the Swedish eID Framework this API is an extension to OASIS Digital Signature Service (\[[SC.DssExt](#sc-dssext)\]). The Signature Service generates a private key and a certificate on behalf of the user and signs the data with this key. Before this is done the Signature Service needs to authenticate the user and obtain his or hers approval to sign. This is done by sending an authentication request to an Identity Provider (in this specification an OpenID Provider).

One advantage of this model is that the actual signature is created at the Signature Service which means that the actual eID being used does not have to be PKI-based, and/or, have the capability to sign. Another advantage is that signatures can be created according to a format decided by the Relying Party, independently of what is supported by any OpenID Providers used by the Relying Party.

One obvious drawback with this model is that is more complex than the delegated signing model. 

The flow below illustrates each step in this use case.

![Federated signing](img/federated-signing.png)

1. The user wants to sign something at the Relying Party, for example a form, and clicks "Sign".

2. The Relying Party (client) now compiles a SignRequest message and includes this when it posts the user agent to the Signature Service. This SignRequest message is according to \[[SC.DssExt](#sc-dssext)\] and contains one, or several, digests of the data to be signed along with elements such as required signature format, required user attributes, which identity provider to use, and much more.

3. Before the Signature Service can proceed it needs to authenticate the user, and obtain his or hers approval to sign the data. So the Signature Service, that is now an OIDC client, initiates an "authentication for signature" by redirecting the user to the OpenID Provider along with an authentication request containing a sign extension (see chapter XX below).

4. The user now authenticates. During this process the OpenID Provider displays a summary of what is to be signed (the sign message). Note that depending on whether the OpenID Provider has signing capabilities or not, the user may actually perform a signature at this stage (see XXX below).

5. After a completed "authentication for signature" operation the user agent is redirected back to the Signature Service along with an authorization code.

6. Next, the Signature Service obtains an ID token that contains information about the user along with a user consent for signature.

7. Now the Signature Service generates a key pair, and signs the data received from the Relying Party (step 2).

8. A SignResponse message according to \[[SC.DssExt](#sc-dssext)\] is now created and posted back to the Relying Party.

9. Finally, the completed signature operation is acknowledged to the user.


<a name="the-signature-request-object"></a>
## 3. The Signature Request Object

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
## 4. Signature Response Data

- `https://claims.oidc.se/userSignature`
- and additional claims ...

<a name="normative-references"></a>
## 5. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

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

