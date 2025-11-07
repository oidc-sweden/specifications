![Logo](img/oidc-logo.png)

# OpenID Federation Deployment and Interoperability Profile

### Version: 1.0 - Draft 00 - 2025-11-03

## Abstract

## Abstract

This document defines a deployment and interoperability profile for OpenID Federation \[[OpenID.Federation](#openid-federation)\]. The profile introduces a constrained and implementation-focused subset of the OpenID Federation specification, designed to simplify deployment and promote interoperability across federations.  

It provides clarifications and extensions that enable entities with protocol roles, such as OpenID Providers, OpenID Connect Relying Parties, OAuth 2.0 Authorization Servers, Clients, and Protected Resources, to join and use an OpenID Federation with minimal effort. The profile also describes mechanisms that allow legacy systems to participate without being fully OpenID Federation-compliant.  

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

    1.2. [Terminology](#terminology)

2. [**Federation Structure**](#federation-structure)

9. [**References**](#references)

    9.1. [Normative References](#normative-references)

    9.2. [Informative References](#informative-references)

---

<a name="introduction"></a>
## 1. Introduction

The OpenID Federation specification \[[OpenID.Federation](#openid-federation)\] defines a general framework for establishing and managing federations of entities participating in identity and authorization protocols such as OpenID Connect and OAuth 2.0. While the standard is powerful and flexible, its generic design allows for a wide range of deployment models, some of which can introduce unnecessary complexity for implementers.

This document defines a deployment and interoperability profile for OpenID Federation. Its purpose is to facilitate straightforward and interoperable federation deployments by providing additional constraints, clarifications, and recommendations. The intent is to enable practical implementations that are easy to deploy and maintain, without requiring a deep understanding of all features of the base specification.

The profile references a limited set of extensions that allow entities such as OpenID Providers (OPs) and OpenID Connect Relying Parties (RPs) to participate in a federation even if they are not fully OpenID Federation-compliant. This enables integration of legacy systems within an OpenID Federation environment while preserving trust and interoperability.

The focus of this profile is to make it simple for entities that perform protocol roles, such as OPs, RPs, OAuth 2.0 Authorization Servers, Clients, and Protected Resources, to join and use a federation. It defines consistent patterns for registration and metadata resolution, allowing such entities to participate with minimal configuration and operational overhead.

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 \[[RFC2119](#rfc2119)\] \[[RFC8174](#rfc8174)\] when, and only when, they appear in all capitals, as shown here.

<a name="terminology"></a>
### 1.2. Terminology

This document extends Section 1.2 of \[[OpenID.Federation](#openid-federation)\] by introducing the following terms to improve the readability of this profile:

<dl>
<dt>Federation Service</dt>
<dd>An entity within the federation that fulfils a protocol role, such as an OpenID Provider, OpenID Connect Relying Party, OAuth 2.0 Authorization Server, OAuth 2.0 Client, or OAuth 2.0 Protected Resource.</dd>

<dt>Federation Node</dt>
<dd>An entity within the federation that is not a Federation Service, such as a Trust Anchor, an Intermediate Entity, or a Trust Mark Issuer.</dd>

<dt>Federation Service Information</dt>
<dd>Data associated with a Federation Service, including entity metadata and Trust Marks, as well as additional information such as policies. Federation Service Information is conveyed as an Entity Statement issued by a Federation Node for a subordinate entity, or as Entity Configuration provided as a self-signed statement by any federation entity.</dd>

<dt>Federation Registration Entity</dt>
<dd>A Superior Entity with which a Federation Service (for example, an OpenID Connect Relying Party) registers to join the federation. This involves the collection of Entity Configuration/metadata, and the creation of an Entity Statement.</dd>

</dl>

<a name="federation-structure"></a>
## 2. Federation Structure

The OpenID Federation standard, \[[OpenID.Federation](#openid-federation)\], is generic and imposes few restrictions on how a federation may be structured. This section introduces a set of requirements and recommendations intended to make OpenID Federation deployments straightforward and easy to maintain.

> Items to cover:
>
> - Legacy Entity Identifiers (client names) - Relevant for this profile?
>
> - Do not combine a Trust Anchor and a Trust Mark Issuer. Explain why.
>
> - A protocol entity (Federation Service) MUST be leaf. 
>
> - Trust Anchors and Registration Entities (intermediates) MUST provider resolve endpoint.
>
> - Prefer using resolve-endpoints over building bottom-up as defined in \[[OpenID.Federation](#openid-federation)\].
>
> - Naming. MUST be URL for Federation Nodes.
>
> - Must not assume support for OIDF (handling legacy systems).
>
> - Avoid using extensions for OpenID Connect and the registration processes as described in \[[OpenID.Federation](#openid-federation)\].
>
> - `federation_entity` MUST not be used by entities having protocol roles. Explain why.

## 3. Entity Registration

"OpenID Connect Dynamic Client Registration", [[OpenID.Registration]](#openid-registration), and "OAuth 2.0 Dynamic Client Registration Protocol", [[RFC7591]](#rfc7591), specify how a client registers at an OpenID Provider or an OAuth 2.0 Authorization Server. Such registrations are performed in a peer-to-peer manner, where a client is registered with a single service. A given client's registration at another service may differ in naming, metadata, and security mechanisms.

In a federative context, however, a client does not register with a specific service. Instead, it registers within the federation itself. This fact implies that the registration data for a client joining the federation needs to be generic in a sense that the registration does not presupposes a particular peer service.

Consequently, an OpenID Provider or an OAuth 2.0 Authorization Server functioning within a federation must be prepared to accept, and incorporate the metadata of an already registered client, to its service configuration.

> Items to over:
> 
> - Write about "registration to the federation" as opposed to "registration at an OP or AS", i.e., registration according section 12 of [[OpenID.Registration]](#openid-registration) vs. registration at a Federaion Registration Entity (intermediate).
>     - The latter enables "federation like" registration. In these cases we need to have a mechanism to notify OPs and AS:s that a new entity has been added ...
> - Hosted entity statements. Why and what is needed. Requires use of resolvers. Will point at extension.


## 4. Legacy System Considerations

> - Naming. Not necessarily a URL. Or?
>
> - Metadata. Make sure to be functioning based on "standard" metadata claims.
> - No registration at particular OP/AS
> - ...

## 5. Resolving Trust Chains and Metadata

> - Resolving Trust Chains and Metadata
>    - Requirements for resolvers
>    - Requirements for caching and handling the resolve response

## 6. Trust Marks

> - Requirements and recommendations
> - Validation process
> - Prefer using short-lived (no revocation will be needed)
>     - For those, we probably want to include a trust mark-pointer in Entity Configuration.
>     - Up-side: Trust mark status endpoint will not be required 
> - Trust mark types, i.e., URL - Recommendation that this URL is related to the Entity Identifier of the TMI.
> - Trust mark requests: MUST/SHOULD require client authentication at the endpoint
> - We need to write about a registration entity requesting trust marks on behalf of a registered entity. In some settings, an entity may not even know that it should posses a certain trust mark.
- > Also, the profile should discuss having the trust marks at a superior entity statement. The main spec. states that trust marks SHOULD only be stored in an entity configuration. A lot of reasons why this is not always a good idea.

## 7. Metadata

> - An entity's metadata should be usable also for non-OIDF consumers
> - Discuss "OpenID Connect Relying Party Metadata Choices". Alternative is to enforce support for a wider range of algorithms.
> - Raise concern about OAuth scopes in metadata.
> - An OP/AS cannot get everything it needs from federation metadata. It must probably combine with a client's trust marks and a policy to configure a client's rights etc.

## 8. Cryptographic Requirements

### 8.1. Algorithm Support    

> TODO: Require support of a wider range of algorithms

<a name="references"></a>
## 9. References

<a name="normative-references"></a>
### 9.1. Normative References

<a name="openid-registration"></a>
**\[OpenID.Registration\]**
> [Sakimura, N., Bradley, J., and M.B. Jones, "OpenID Connect Dynamic Client Registration 1.0", 15 December 2023](https://openid.net/specs/openid-connect-registration-1_0.html).

<a name="openid-discovery"></a>
**\[OpenID.Discovery\]**
> [Sakimura, N., Bradley, J., Jones, M.B., and E. Jay, "OpenID Connect Discovery 1.0", 15 December 2023](https://openid.net/specs/openid-connect-discovery-1_0.html).

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [Hedberg, R., Jones, M.B., Solberg, A.Å., Bradley, J., De Marco, G., and V. Dzhuvinov, "OpenID Federation 1.0", 15 October 2025](https://openid.net/specs/openid-federation-1_0.html).

<a name="openid-rp-choices"></a>
**\[OpenID.RP.Choices\]**
> [Jones, M.B., Hedberg, R., Bradley, J., and F. Skokan, "OpenID Connect Relying Party Metadata Choices 1.0", 19 September 2025](https://openid.net/specs/openid-connect-rp-metadata-choices-1_0.html).

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", BCP 14, RFC 2119, DOI 10.17487/RFC2119, March 1997](https://www.rfc-editor.org/info/rfc2119).

<a name="rfc7591"></a>
**\[RFC7591\]**
> [Richer, J., Ed., Jones, M., Bradley, J., Machulak, M., and P. Hunt, "OAuth 2.0 Dynamic Client Registration Protocol", RFC 7591, DOI 10.17487/RFC7591, July 2015](https://www.rfc-editor.org/info/rfc7591).

<a name="rfc8174"></a>
**\[RFC8174\]**
> [Leiba, B., "Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words", BCP 14, RFC 8174, DOI 10.17487/RFC8174, May 2017](https://www.rfc-editor.org/info/rfc8174).

<a name="informative-references"></a>
### 9.2. Informative References