![Logo](img/oidc-logo.png)

# OpenID Federation Deployment and Interoperability Profile

### Version: 1.0 - Draft 00 - 2025-11-18

## Abstract

## Abstract

This document defines a deployment and interoperability profile for OpenID Federation \[[OpenID.Federation](#openid-federation)\]. The profile introduces a constrained and implementation-focused subset of the OpenID Federation specification, designed to simplify deployment and promote interoperability across federations.  

It provides clarifications and extensions that enable entities with protocol roles, such as OpenID Providers, OpenID Connect Relying Parties, OAuth 2.0 Authorization Servers, Clients, and Protected Resources, to join and use an OpenID Federation with minimal effort. The profile also describes mechanisms that allow legacy systems to participate without being fully OpenID Federation-compliant.  

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

    1.2. [Terminology](#terminology)

2. [**Federation Structure**](#federation-structure)

    2.1. [Federation Entity Types](#federation-entity-types)

    2.2. [Use of Resolvers](#use-of-resolvers)

    2.3. [Hosted Entity Configurations](#hosted-entity-configurations)
    
    2.4. [Federation Hierarchy Requirements and Recommendations](#federation-hierarchy-requirements-and-recommendations)

    2.4.1. [Chaining Models](#chaining-models)

    2.4.2. [Trust Anchor and Trust Mark Issuer Roles](#trust-anchor-and-trust-mark-issuer-roles)

    2.4.3. [Metadata Policy Declarations](#metadata-policy-declarations)

3. [**Entity Registration**](#entity-registration)

4. [**Resolving Metadata and Trust Marks**](#resolving-metadata-and-trust-marks)

5. [**Trust Marks**](#trust-marks)

6. [**Metadata**](#metadata)

7. [**Federation Policies**](#federation-policies)

8. [**References**](#references)

    8.1. [Normative References](#normative-references)

    8.2. [Informative References](#informative-references)

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

<dt>Federation Protocol Entity</dt>
<dd>An entity within the federation that fulfils a protocol role, such as an OpenID Provider, OpenID Connect Relying Party, OAuth 2.0 Authorization Server, OAuth 2.0 Client, or OAuth 2.0 Protected Resource. This is typically a Leaf Entity.</dd>

<dt>Federation Service Entity</dt>
<dd>An entity within the federation that does not play a protocol role but instead takes on an operational role within the federation, such as a Trust Anchor, an Intermediate Entity, or a Trust Mark Issuer.</dd>

<dt>Federation Registration Entity</dt>
<dd>A Superior Entity within the federation with which a Protocol Entity (for example, an OpenID Connect Relying Party) registers to join the federation. This involves the collection of Entity Configuration and metadata, and the creation of an Entity Statement.</dd>

<dt>Federation Resolver</dt>
<dd>A Federation Service Entity that provides functionality for obtaining Resolved Metadata and Trust Marks for a given Entity.</dd>

</dl>

<a name="federation-structure"></a>
## 2. Federation Structure

The OpenID Federation standard, \[[OpenID.Federation](#openid-federation)\], is generic and imposes few restrictions on how a federation may be structured. This section introduces a set of requirements and recommendations intended to make OpenID Federation deployments straightforward and easy to maintain.

<a name="federation-entity-types"></a>
### 2.1. Federation Entity Types

\[[OpenID.Federation](#openid-federation)\] does not restrict how federation roles may be combined by a Federation Entity operating under a single Entity Identifier. However, combining the role of an Intermediate Entity with that of a Federation Protocol Entity, such as an OpenID Provider, can introduce challenges and unnecessary complexity. Most importantly, it may lead to conflicts between the contents of the `metadata` claim and the `metadata_policy` claim in subordinate Entity Statements.

Therefore, implementers of this profile MUST NOT combine the role of a Trust Anchor, Intermediate Entity, Trust Mark Issuer, or Federation Resolver with that of a Federation Protocol Entity under the same Entity Identifier.  

This requirement implies that a Federation Protocol Entity is always a Leaf Entity and that its Entity Configuration MUST NOT include metadata of type `federation_entity`.

<a name="use-of-resolvers"></a>
### 2.2. Use of Resolvers

Section 10 of \[[OpenID.Federation](#openid-federation)\] specifies requirements for how an entity resolves the trust chain and metadata of another entity with which it wishes to establish trust. This process includes fetching Entity Statements, applying metadata policies and constraints, validating trust chains, and handling caching. The procedure is complex and may be difficult for all Federation Protocol Entities within the federation to implement. 

Also, this algorithm relies on all participants publishing their Entity Configuration information at a well-known location, as specified in Section 9 of \[[OpenID.Federation](#openid-federation)\]. However,
this profile references an alternative way of publishing Entity Configuration (see [Section 2.3, Hosted Entity Configurations](#hosted-entity-configurations) below), that requires a resolver algorithm starting with a Trust Anchor instead of the bottom-up approach specified in Section 10 of \[[OpenID.Federation](#openid-federation)\].

Therefore, it is RECOMMENDED that entities compliant with this profile use a Federation Resolver in order to resolve metadata and trust for peer entities. A Federation Resolver is an entity within the federation that provides a `federation_resolve_endpoint` as specified in Sections 5.1.1 and 8.3 of \[[OpenID.Federation](#openid-federation)\].

A Trust Anchor adhering to this profile MUST ensure the availability of at least one Federation Resolver compliant with the requirements stated in this profile. This resolver MUST support resolving for the given Trust Anchor and MUST be either provided as part of the Trust Anchor or be a subordinate entity to the Trust Anchor.

[Section 4, Resolving Metadata and Trust Marks](#resolving-metadata-and-trust-marks) specifies further requirements for Federation Resolver usage and implementation. 

<a name="hosted-entity-configurations"></a>
### 2.3. Hosted Entity Configurations

The specification "OpenID Federation Entity Configuration Hosting", \[[OpenID.Federation.Hosting](#openid-federation-hosting)\], defines the Entity Statement extension claim `ec_location`. The primary purpose of this claim is to enable hosting of a Leaf Entity's Entity Configuration data at an alternate location from that specified in Section 9 of the \[[OpenID.Federation](#openid-federation)\] standard.

Using this claim, an OpenID Federation deployment can allow entities that do not support the \[[OpenID.Federation](#openid-federation)\] standard, or that for other reasons cannot meet its requirements for publishing Entity Configuration at a well-known location, to participate in the federation.

For deployments adhering to this profile it is RECOMMENDED that the `ec_location` extension claim is supported. Furthermore, Superior Entities that support the claim SHOULD include the claim in all published Entity Statements, even if the subject's Entity Configuration is published at the well-known location as specified in \[[OpenID.Federation](#openid-federation)\]. The reason for this is to offer a uniform way for resolvers to locate the subject Entity Configuration.

<a name="federation-hierarchy-requirements-and-recommendations"></a>
### 2.4. Federation Hierarchy Requirements and Recommendations

\[[OpenID.Federation](#openid-federation)\] defines an infrastructure in which multiple federation contexts may co-exist without clear boundaries between them. Each federation context is anchored by a common Trust Anchor. A Trust Anchor defines a policy that all subordinate services must satisfy in order for their metadata to be validated through that Trust Anchor.

A Federation Protocol Entity or Federation Service Entity may chain to more than one Trust Anchor. Chaining to a Trust Anchor does not, however, guarantee successful validation. Validation succeeds only if the Federation Protocol Entity's metadata conforms to the combined metadata policies of all entities in the chain up to and including the Trust Anchor.

It is therefore important to structure the hierarchy of Federation Service Entities and their metadata policies carefully. The aim is to enforce essential rules while avoiding the unintended blocking of legitimate services due to incompatible policy applications.

This section contains sub-sections with requirements and recommendations for structuring a federation hierarchy in order to avoid unnecessary complexity and pitfalls.

<a name="chaining-models"></a>
#### 2.4.1. Chaining Models

Federation Protocol Entities SHOULD NOT be chained directly under a Trust Anchor. Instead, they SHOULD be chained to an Intermediate Entity (that is chained to the Trust Anchor). This requirement enables chaining a Federation Protocol Entity to other federation contexts, that is a chain ending at a different Trust Anchor, without the risk of metadata policy conflicts as described above.

It is also RECOMMENDED that Federation Protocol Entities that need to be available under a common Trust Anchor chain to a common Intermediate Entity. This makes it easier for that Trust Anchor to create a chain to groups of Federation Protocol Entities by creating a single chain link to the common Intermediate Entity.

A Trust Anchor SHOULD NOT be chained directly to another Trust Anchor in order to minimise risks of merge conflicts between Trust Anchor metadata policies.

<a name="trust-anchor-and-trust-mark-issuer-roles"></a>
#### 2.4.2. Trust Anchor and Trust Mark Issuer Roles

Trust Anchors may apply different metadata policies to the same Entity. That is, one Trust Anchor may restrict the set of metadata preferences in one way, while another imposes a different and potentially incompatible set of restrictions. When these policies cannot be reconciled into a single combined policy, a Trust Anchor that wants to support entities recognised by another Trust Anchor must chain directly to a Subordinate Entity under that other Trust Anchor rather than chaining to the other Trust Anchor itself. See [Section 2.4.1](#chaining-models) above.

However, this approach is no longer viable when the other Trust Anchor also operates as a Trust Mark Issuer whose Trust Marks are required to be understood by all entities. Chaining to a Subordinate Entity bypasses the Trust Anchor role and therefore excludes trust in the Trust Mark Issuer. Attempting to resolve this by chaining directly to the Trust Mark Issuer is also problematic because such chaining implicitly creates an additional path through the other Trust Anchor, resulting in two possible trust paths, one of which may fail due to policy conflicts.

These issues are inherently difficult to resolve and introduce ambiguity and inconsistency in the trust path evaluation process. Therefore, deployments compliant with this profile SHOULD NOT allow Trust Anchors to also function as Trust Mark Issuers.

<a name="metadata-policy-declarations"></a>
#### 2.4.3. Metadata Policy Declarations

Merge of metadata policies in a Trust Chain may lead to merge conflicts, making it impossible to validate metadata through that chain in any meaningful way. This risk increases if complex policies are defined by lower entities in the chain.

Deployments compliant with this profile SHOULD therefore concentrate metadata policy expression at Trust Anchors, and only express metadata policies at Intermediate Entity levels in exceptional cases.

Adhering to this requirement, combined with the requirement stated in [Section 2.4.1](#chaining-models) about not chaining Federation Protocol Entities directly under a Trust Anchor, enables the construction of alternative paths to other Trust Anchors without having to apply multiple Trust Anchor metadata policies, and thus avoids merge errors caused by incompatible policies.

<a name="entity-registration"></a>
## 3. Entity Registration

"OpenID Connect Dynamic Client Registration", \[[OpenID.Registration](#openid-registration)\], and "OAuth 2.0 Dynamic Client Registration Protocol", \[[RFC7591](#rfc7591)\], specify how a client registers at an OpenID Provider or an OAuth 2.0 Authorization Server. Such registrations are performed in a peer-to-peer manner, where a client is registered with a single service. A given client's registration at another service may differ in naming, metadata, and security mechanisms.

In a federative context, however, a client does not register with a specific service. Instead, it registers within the federation itself. This fact implies that the registration data for a client joining the federation needs to be generic in a sense that the registration does not presupposes a particular peer service.

Consequently, an OpenID Provider or an OAuth 2.0 Authorization Server functioning within a federation must be prepared to accept, and incorporate the metadata of an already registered client, to its service configuration.

> Items to over:
> 
> - Write about "registration to the federation" as opposed to "registration at an OP or AS", i.e., registration according section 12 of \[[OpenID.Registration](#openid-registration)\] vs. registration at a Federaion Registration Entity (intermediate).
>     - The latter enables "federation like" registration. In these cases we need to have a mechanism to notify OPs and AS:s that a new entity has been added ...
> - Hosted entity statements. Why and what is needed. Requires use of resolvers. Will point at extension.

Registration policy. I constraining mechanism ...
Utökning: ID för policy. Supported registration policies.

Eget kapitel för lagring av Entity Configuration.


<a name="resolving-metadata-and-trust-marks"></a>
## 4. Resolving Metadata and Trust Marks

> - Resolving Trust Chains and Metadata
>    - Requirements for resolvers
>    - Requirements for caching and handling the resolve response

Får inte lita på ett response längre än vad ingående trust marks är giltiga.

Resolver builds from top down!

Can we allow to not include trust chain?

> Simplest way for handling trusted certs - only to resolver.

<a name="trust-marks"></a>
## 5. Trust Marks

> - Requirements and recommendations
> - Validation process
> - Prefer using short-lived (no revocation will be needed)
>     - For those, we probably want to include a trust mark-pointer in Entity Configuration.
>     - Up-side: Trust mark status endpoint will not be required 
> - Trust mark types, i.e., URL - Recommendation that this URL is related to the Entity Identifier of the TMI.
> - [Trust mark requests: MUST/SHOULD require client authentication at the endpoint]
> - We need to write about a registration entity requesting trust marks on behalf of a registered entity. In some settings, an entity may not even know that it should posses a certain trust mark.
- > Also, the profile should discuss having the trust marks at a superior entity statement. The main spec. states that trust marks SHOULD only be stored in an entity configuration. A lot of reasons why this is not always a good idea.

Policy that a trustmark older than a configurable value must/should be checked for validity against a tm status endpoint.

Self-signed: loa3-unspecified

<a name="metadata"></a>
## 6. Metadata

> - An entity's metadata should be usable also for non-OIDF consumers
> - Discuss "OpenID Connect Relying Party Metadata Choices". Alternative is to enforce support for a wider range of algorithms.
> - Raise concern about OAuth scopes in metadata.
> - An OP/AS cannot get everything it needs from federation metadata. It must probably combine with a client's trust marks and a policy to configure a client's rights etc.

Policy: Own chapter ...

> - Metadata. Make sure to be functioning based on "standard" metadata claims.
> - No registration at particular OP/AS
> - Algorithm support

It is each entities responsibility to create metadata that is functional by the intended peers.

<a name="federation-policies"></a>
## 7. Federation Policies

An Entity's Entity Configuration contains a `metadata` claim in which the Entity declares parameters about its preferences and capabilities. A metadata policy, as specified in Section 6.1 of \[[OpenID.Federation](#openid-federation)\], MAY be added to Subordinate Statements in order to modify the metadata declared by an Entity.

Metadata policies can be declared by any Entity in a Trust Chain that publishes Subordinate Statements. Unpredictable situations may arise if the merged policy of a Trust Chain adds parameter values that were not originally declared by the Entity to the resulting metadata. Such policy usage may create situations where the metadata resolved for an Entity contains a capability or preference that the Entity cannot handle.

Therefore, this profile specifies the following requirements:

- Adding metadata parameter values to an Entity's metadata SHOULD be limited to the Entity itself and its Immediate Superior Entity handling its registration.

- If an Immediate Superior Entity needs to add metadata parameter values to an Entity's resolved metadata it SHOULD do so by declaring these values using metadata declarations in the Entity Statement issued for the Entity, and SHOULD NOT use metadata policy operators.

<a name="references"></a>
## 8. References

<a name="normative-references"></a>
### 8.1. Normative References

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

<a name="openid-federation-hosting"></a>
**\[OpenID.Federation.Hosting\]**
> Santesson, S., Lindström, M., "OpenID Federation Entity Configuration Hosting", November 2025.

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
### 8.2. Informative References