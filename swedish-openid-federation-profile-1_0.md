%%%
title = "Swedish OpenID Federation Deployment and Interoperability Profile 1.0 - draft 00"
abbrev = "swedish-openid-federation-profile"
ipr = "none"
workgroup = "OIDC Sweden"
keyword = ["security", "openid", "ssi"]

[seriesInfo]
name = "Internet-Draft"
value = "swedish-openid-federation-profile"
status = "standard"

[[author]]
initials="M."
surname="Lindström"
fullname="Martin Lindström"
organization="IDsec Solutions"
    [author.address]
    email = "martin@idsec.se"

[[author]]
initials="S."
surname="Santesson"
fullname="Stefan Santesson"
organization="IDsec Solutions"
    [author.address]
    email = "stefan@idsec.se"
    
[[contact]]
fullname="Per Mützell"

[[contact]]
fullname="Stefan Halén"

[[contact]]
fullname="Stefan Halén"

[[contact]]
fullname="Martin Solberg"

[[contact]]
fullname="e-Hälsomyndigheten"

%%%

.# Abstract

This document defines a deployment and interoperability profile for OpenID Federation [@!OpenID.Federation]. The profile introduces a constrained and implementation-focused subset of the OpenID Federation specification, designed to simplify deployment and promote interoperability across federations.  

It provides clarifications and extensions that enable entities with protocol roles, such as OpenID Providers, OpenID Connect Relying Parties, OAuth 2.0 Authorization Servers, Clients, and Protected Resources, to join and use an OpenID Federation with minimal effort. The profile also describes mechanisms that allow legacy systems to participate without being fully OpenID Federation-compliant.  

{mainmatter}

# Introduction

The OpenID Federation specification [@!OpenID.Federation] defines a general framework for establishing and managing federations of entities participating in identity and authorization protocols such as OpenID Connect and OAuth 2.0. While the standard is powerful and flexible, its generic design allows for a wide range of deployment models, some of which can introduce unnecessary complexity for implementers.

This document defines a deployment and interoperability profile for OpenID Federation. Its purpose is to facilitate straightforward and interoperable federation deployments by providing additional constraints, clarifications, and recommendations. The intent is to enable practical implementations that are easy to deploy and maintain, without requiring a deep understanding of all features of the base specification.

The profile references a limited set of extensions that allow entities such as OpenID Providers (OPs) and OpenID Connect Relying Parties (RPs) to participate in a federation even if they are not fully OpenID Federation-compliant. This enables integration of legacy systems within an OpenID Federation environment while preserving trust and interoperability.

The focus of this profile is to make it simple for entities that perform protocol roles, such as OPs, RPs, OAuth 2.0 Authorization Servers, Clients, and Protected Resources, to join and use a federation. It defines consistent patterns for registration and metadata resolution, allowing such entities to participate with minimal configuration and operational overhead.

## Requirements Notation and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in
this document are to be interpreted as described in BCP 14 [@!RFC2119]
[@!RFC8174] when, and only when, they appear in all capitals, as shown here.

## Terminology

This document extends [@!OpenID.Federation, section 1.2] by introducing the following terms to improve the readability of this profile:

Federation Protocol Entity
: <br>An entity within the federation that fulfils a protocol role, such as an OpenID Provider, OpenID Connect Relying Party, OAuth 2.0 Authorization Server, OAuth 2.0 Client, or OAuth 2.0 Protected Resource. This is typically a Leaf Entity.<br>

Federation Service Entity
: <br>An entity within the federation that does not play a protocol role but instead takes on an operational role within the federation, such as a Trust Anchor, an Intermediate Entity, or a Trust Mark Issuer.<br>

Federation Registration Entity
: <br>A Superior Entity within the federation with which a Federation Protocol Entity (for example, an OpenID Connect Relying Party) registers to join the federation. This involves the collection of Entity Configuration and metadata, and the creation of an Entity Statement.<br>

Federation Resolver
: <br>A Federation Service Entity that provides functionality for obtaining Resolved Metadata and Trust Marks for a given Entity.

# Structuring Federation Deployments {#structuring_federation_deployments}

The OpenID Federation standard [@!OpenID.Federation], is generic and imposes few restrictions on how a federation may be structured. This section introduces a set of requirements and recommendations intended to make OpenID Federation deployments straightforward and easy to maintain.

## Federation Entity Types {#federation_entity_types}

[@!OpenID.Federation] does not restrict how federation roles may be combined by a Federation Entity operating under a single Entity Identifier. However, combining the role of an Intermediate Entity with that of a Federation Protocol Entity, such as an OpenID Provider, can introduce challenges and unnecessary complexity. Most importantly, it may lead to conflicts between the contents of the `metadata` Claim and the `metadata_policy` Claim in subordinate Entity Statements.

Therefore, implementers of this profile **MUST NOT** combine the role of a Trust Anchor, Intermediate Entity, Trust Mark Issuer, or Federation Resolver with that of a Federation Protocol Entity under the same Entity Identifier.

This requirement implies that a Federation Protocol Entity is always a Leaf Entity and that its Entity Configuration **MUST NOT** include metadata of type `federation_entity`.

## Use of Resolvers {#use_of_resolvers}

[@!OpenID.Federation, section 10] specifies requirements for how an Entity resolves the Trust Chain and metadata of another Entity with which it wishes to establish trust. This process includes fetching Entity Statements, applying metadata policies and constraints, validating Trust Chains, and handling caching. The procedure is complex and may be difficult for all Federation Protocol Entities within the federation to implement. 

Also, this algorithm relies on all participants publishing their Entity Configuration information at a well-known location, as specified in [@!OpenID.Federation, section 9]. However, this profile references an alternative way of publishing Entity Configuration (see (#hosted_entity_configurations) below), that requires a resolver algorithm starting with a Trust Anchor instead of the bottom-up approach specified in [@!OpenID.Federation, section 10].

Therefore, it is **RECOMMENDED** that entities compliant with this profile use a Federation Resolver in order to resolve metadata and trust for peer entities. A Federation Resolver is an entity within the federation that provides a `federation_resolve_endpoint` as specified in Sections [@!OpenID.Federation, 5.1.1] and [@!OpenID.Federation, 8.3] of [@!OpenID.Federation].

A Trust Anchor adhering to this profile **MUST** ensure the availability of at least one Federation Resolver compliant with the requirements stated in this profile. This resolver **MUST** support resolving for the given Trust Anchor. It is **RECOMMENDED** that the resolver is provided as part of the Trust Anchor itself.

A> If the resolver is provided by a Subordinate Entity to the Trust Anchor, federation participants that entirely relies on the use of the resolver will have to configure two trusted federation keys; both to the Trust Anchor and to the Entity implementing the Federation Resolver. See [@!OpenID.Registration, section 8.3.3].

(#resolving_metadata_and_trust_marks), (#resolving_metadata_and_trust_marks, use title), specifies further requirements for Federation Resolver usage and implementation. 

## Entity Configuration

This section defines requirements and recommendations for Entity Configurations, as defined in [@!OpenID.Federation, section 3].

### Entity Configuration Validity {#entity_configuration_validity}

The validity period of an Entity Configuration is controlled by the `exp` Claim. Setting a short validity period undermines effective caching and places a burden on the owning Entity to continuously update and sign the Entity Configuration. Conversely, setting long validity periods may delay the propagation of metadata changes, as older versions may remain cached.

A> TODO: Suggest that federation policies recommend sensible values for validity. 

A> TODO: Requirement that Entities MUST update Entity Configuration more oftenly than what is stated in the `exp` Claim. 

A> TODO: Unclear in main spec. If short-lived Trust Marks are being used. Do they have an effect on EC validity?

### Hosted Entity Configurations {#hosted_entity_configurations}

The specification "OpenID Federation Entity Configuration Hosting" [@!OpenID.Federation.Hosting] defines the Entity Statement extension Claim `ec_location`. The primary purpose of this Claim is to enable hosting of a Leaf Entity's Entity Configuration data at an alternate location from that specified in [@!OpenID.Federation, section 9].

Using this Claim, an OpenID Federation deployment can allow entities that do not support the [@!OpenID.Federation] standard, or that for other reasons cannot meet its requirements for publishing Entity Configuration at a well-known location, to participate in the federation.

For deployments adhering to this profile it is **RECOMMENDED** that the `ec_location` extension Claim is supported. Furthermore, it is **RECOMMENDED** that Superior Entities supporting the Claim include the Claim in all published Entity Statements, even if the subject's Entity Configuration is published at the well-known location as specified in [@!OpenID.Federation]. The reason for this is to offer a uniform way for resolvers to locate the subject Entity Configuration.

## Federation Policies {#federation_policies}

An Entity's Entity Configuration contains a `metadata` Claim in which the Entity declares parameters about its preferences and capabilities. A metadata policy, as specified in Section 6.1 of [@!OpenID.Federation], **MAY** be added to Subordinate Statements in order to modify the metadata declared by an Entity.

Metadata policies can be declared by any Entity in a Trust Chain that publishes Subordinate Statements. Unpredictable situations may arise if the merged policy of a Trust Chain adds parameter values that were not originally declared by the Entity to the resulting metadata. Such policy usage may create situations where the metadata resolved for an Entity contains a capability or preference that the Entity cannot handle.

Therefore, this profile specifies the following requirements:

- Adding metadata parameter values to an Entity's metadata **SHOULD** be limited to the Entity itself and its Immediate Superior Entity handling its registration.

- If an Immediate Superior Entity needs to add metadata parameter values to an Entity's resolved metadata it **SHOULD** do so by declaring these values using metadata declarations in the Entity Statement issued for the Entity, and **SHOULD NOT** use metadata policy operators.

A> TODO: Consider merging with (#metadata_policy_declarations)

## Federation Hierarchy Requirements and Recommendations {#federation_hierarchy_requirements_and_recommendations}

[@!OpenID.Federation] defines an infrastructure in which multiple federation contexts may co-exist without clear boundaries between them. Each federation context is anchored by a common Trust Anchor. A Trust Anchor defines a policy that all subordinate services must satisfy in order for their metadata to be validated through that Trust Anchor.

A Federation Protocol Entity or Federation Service Entity may chain to more than one Trust Anchor. Chaining to a Trust Anchor does not, however, guarantee successful validation. Validation succeeds only if the Federation Protocol Entity's metadata conforms to the combined metadata policies of all entities in the Trust Chain up to and including the Trust Anchor.

It is therefore important to structure the hierarchy of Federation Service Entities and their metadata policies carefully. The aim is to enforce essential rules while avoiding the unintended blocking of legitimate services due to incompatible policy applications.

This section contains sub-sections with requirements and recommendations for structuring a federation hierarchy in order to avoid unnecessary complexity and pitfalls.

### Chaining Models {#chaining_models}

Federation Protocol Entities **SHOULD NOT** be chained directly under a Trust Anchor. Instead, they **SHOULD** be chained to an Intermediate Entity (that is chained to the Trust Anchor). This requirement enables chaining a Federation Protocol Entity to other federation contexts, that is a chain ending at a different Trust Anchor, without the risk of metadata policy conflicts as described above.

It is also **RECOMMENDED** that Federation Protocol Entities that need to be available under a common Trust Anchor chain to a common Intermediate Entity. This makes it easier for that Trust Anchor to create a chain to groups of Federation Protocol Entities by creating a single chain link to the common Intermediate Entity.

A Trust Anchor **SHOULD NOT** be chained directly to another Trust Anchor in order to minimise risks of merge conflicts between Trust Anchor metadata policies.

### Trust Anchor and Trust Mark Issuer Roles {#trust_anchor_and_trust_mark_issuer_roles}

Trust Anchors may apply different metadata policies to the same Entity. That is, one Trust Anchor may restrict the set of metadata preferences in one way, while another imposes a different and potentially incompatible set of restrictions. When these policies cannot be reconciled into a single combined policy, a Trust Anchor that wants to support entities recognised by another Trust Anchor must chain directly to a Subordinate Entity under that other Trust Anchor rather than chaining to the other Trust Anchor itself. See (#chaining_models) above.

However, this approach is no longer viable when the other Trust Anchor also operates as a Trust Mark Issuer whose Trust Marks are required to be understood by all Entities. Chaining to a Subordinate Entity bypasses the Trust Anchor role and therefore excludes trust in the Trust Mark Issuer. Attempting to resolve this by chaining directly to the Trust Mark Issuer is also problematic because such chaining implicitly creates an additional path through the other Trust Anchor, resulting in two possible trust paths, one of which may fail due to policy conflicts.

These issues are inherently difficult to resolve and introduce ambiguity and inconsistency in the trust path evaluation process. Therefore, deployments compliant with this profile **SHOULD NOT** allow Trust Anchors to also function as Trust Mark Issuers.

### Metadata Policy Declarations {#metadata_policy_declarations}

Merge of metadata policies in a Trust Chain may lead to merge conflicts, making it impossible to validate metadata through that chain in any meaningful way. This risk increases if complex policies are defined by lower entities in the chain.

There are basically two types of metadata parameters tied to an Entity; parameters that describe the Entity, for example, its display name, logotype, and organizational belonging, and parameters holding security and functional settings, such as keys, algorithms and URLs.

Deployments compliant with this profile **SHOULD** concentrate metadata policies that control security and functional settings at Trust Anchors.

Adhering to this requirement, combined with the requirement stated in (#chaining_models) about not chaining Federation Protocol Entities directly under a Trust Anchor, enables the construction of alternative paths to other Trust Anchors without having to apply multiple Trust Anchor metadata policies, and thus avoids merge errors caused by incompatible policies.

# Entity Registration {#entity_registration}

"OpenID Connect Dynamic Client Registration" [@!OpenID.Registration] and "OAuth 2.0 Dynamic Client Registration Protocol" [@!RFC7591] specify how a Client registers at an OpenID Provider or an OAuth 2.0 Authorization Server. Such registrations are performed in a peer-to-peer manner, where a Client is registered with a single service. A given Client's registration at another service may differ in naming, metadata, and security mechanisms.

When a Client joins a federation, it registers, not at a specific service, but to the federation itself. This fact implies that the registration data for a Client joining the federation **MUST** be generic in a sense that the registration does not presupposes a particular peer service. This also applies for other Entity types other than OAuth 2.0 Clients and OpenID Relying Parties.

Consequently, an OpenID Provider or an OAuth 2.0 Authorization Server compliant with this profile **MUST** be prepared to accept, and incorporate the metadata of an already registered Client, to its service configuration.

## Role of the Federation Registration Entity {#role_of_the_federation_registration_entity}

A Federation Registration Entity is a Superior Entity within the federation with which a Federation Protocol Entity (for example, an OpenID Connect Relying Party) registers to join the federation.

How the registration is initiated is out of scope for this profile, but one example is that the Federation Registration Entity provides an application to which Entity administrators log in and request registration for their Entity.

The Federation Registration Entity registers an Entity by creating and signing a Subordinate Statement for this Entity. Thus, the following aspects of an Entity being registered are vouched for by its Immediate Superior Entity:

- The binding of a federation key to an Entity Identifier.

- That the Entity holding the federation key is the legitimate Entity representing this Entity Identifier.

- That the Entity holding the federation key is a legitimate member of the community implied by membership within a particular federation and can be trusted as such.

The registration is performed according to a Registration Policy, and in order for other participants within a federation to trust a registered Entity, they must trust and accept the policy under which the Entity joined the federation. See (#use_of_registration_policies) below.

If the Federation Registration Entity includes metadata policies in Subordinate Statements, these policies **SHOULD** be limited to fixating descriptive Entity metadata values that were controlled during registration. Typically, such values are display names or organizational belonging. Constraining other metadata values is the responsibility of the Trust Anchor, see (#metadata_policy_declarations).   

An Intermediate Entity acting as a Federation Registration Entity and compliant with this profile **MUST** expose a subordinate listing endpoint as defined in [@!OpenID.Registration, section 8.2].

## Use of Registration Policies {#use_of_registration_policies}

A Federation Registration Entity that creates a Subordinate Statement for an Entity follows a set of rules, described by a Registration Policy, during the registration process. Such rules may comprise:

- Checks to ensure that the organization behind the Entity has entered into the required agreements necessary for federation membership.

- Checks to ensure that the individual requesting that the Entity be added to the federation is authorized to do so, for example by validating that the person is authorized to represent the organization that owns the Entity. This may also involve requirements on the authentication strength for the Entity administrator.

- Checks to determine the ownership of domains. This is especially important when Entity Configuration Hosting is supported, see [@!OpenID.Federation.Hosting, section 4.1].

- Assertions that Entity informational metadata parameters such as `organization_name` and `display_name` contain values that correspond to the organization behind the Entity.

It is **RECOMMENDED** that federation deployments compliant with this profile define Registration Policy URIs for the policies that are used for registering Entities, and that Federation Registration Entities include the `registration_policy` Claim as defined by [@!OpenID.Federation.RegPolicy].

# Resolving Metadata and Trust Marks {#resolving_metadata_and_trust_marks}

As described in (#use_of_resolvers), this profile recommends the use of Federation Resolvers to resolve peer metadata and Trust Marks. This section defines requirements and recommendations for both Entities implementing a Federation Resolver and Entities using a Federation Resolver.

## Federation Resolver Requirements {#federation_resolver_requirements}

A Trust Anchor or an Intermediate Entity that provides a `federation_resolve_endpoint` is regarded to be a Federation Resolver. 

This section extends the requirements specified in [@!OpenID.Registration, section 8.3] with the following statements:

A Federation Resolver **MAY** include Trust Marks that are not present in an Entity's Entity Configuration. It can do so by communicating directly with a Trust Mark Issuer.

A> This functionality may be useful in cases when Trust Marks are being used a control mechanism within the federation and Entities within the federation are unaware of a particular Trust Mark type.

The requirements for the resolve response `exp` Claim given in [@!OpenID.Registration, section 8.3.2] states that the validity of the response must not exceed the validities of the underlying Trust Chain and Trust Marks included. If a Trust Mark instance for the Entity is being resolved is either expired, or has a validity that is shorter than the validity of the Trust Chain, it is **RECOMMENDED** that the resolver obtains a new Trust Mark instance for the Entity by calling the Trust Mark endpoint at the Trust Mark Issuer.

A> By following this requirement, the Federation Resolver avoids issuing resolve responses with unnecessarily short validity periods. This reduces the frequency of resolve requests, as longer-lived responses are more amenable to caching by consuming parties.

## Using a Federation Resolver {#using_a_federation_resolver}

A> TODO: Requirements for caching and handling the resolve response

A> TODO: A consumer must not trust a response longer than its validity, or?

A> TODO: Limitation: Trust chains must be included according to the spec, but is not needed in most cases. Mention that most consumers can ignore.

A> Trust to the resolver if not TA.

# Trust Marks {#trust_marks}

> - Requirements and recommendations
> - Validation process
> - Short-lived (no revocation will be needed) vs. Long-lived (status check required)
>     - For short-lived, we probably want to include a trust mark-pointer in Entity Configuration. Up-side: Trust mark status endpoint will not be required 
> - Trust mark types, i.e., URL - Recommendation that this URL is related to the Entity Identifier of the TMI.
> - [Trust mark requests: Require client authentication at the endpoint? Depends on intended usage.]
> - We need to write about a registration entity requesting trust marks on behalf of a registered entity. In some settings, an entity may not even know that it should posses a certain trust mark.
> - Also, the profile should discuss having the trust marks at a superior entity statement. The main spec. states that trust marks SHOULD only be stored in an entity configuration. A lot of reasons why this is not always a good idea.
> - Policy that a trustmark older than a configurable value must/should be checked for validity against a tm status endpoint.
> - Self-signed: for example for `loa3-unspecified`.
> - Naming

# Metadata {#metadata}

> - An entity's metadata should be usable also for non-OIDF consumers
> - Discuss "OpenID Connect Relying Party Metadata Choices". Alternative is to enforce support for a wider range of algorithms.
> - Raise concern about OAuth scopes in metadata.
> - An OP/AS cannot get everything it needs from federation metadata. It must probably combine with a client's trust marks and a policy to configure a client's rights etc.
> - Metadata. Make sure to be functioning based on "standard" metadata claims.
> - No registration at particular OP/AS
> - Algorithm support
> - It is each entities responsibility to create metadata that is functional by the intended peers.
> - Client authn
> - `organization_identifier`


# Acknowledgments

We would like to thank the following individuals for their comments, ideas, and contributions to this implementation profile and to the initial set of implementations.

- [@Per Mützell], Inera

- Anders Malmros, Inera

- [@Stefan Halén], Internetstiftelsen

- [@Martin Solberg], [@e-Hälsomyndigheten]

{backmatter}

<reference anchor="OpenID.Discovery" target="https://openid.net/specs/openid-connect-discovery-1_0.html">
  <front>
    <title>OpenID Connect Discovery 1.0</title>
    <author fullname="Nat Sakimura" initials="N." surname="Sakimura">
      <organization abbrev="NAT.Consulting (was at NRI)">NAT.Consulting</organization>
    </author>
    <author fullname="John Bradley" initials="J." surname="Bradley">
      <organization abbrev="Yubico (was at Ping Identity)">Yubico</organization>
    </author>
    <author fullname="Michael B. Jones" initials="M.B." surname="Jones">
      <organization abbrev="Self-Issued Consulting (was at Microsoft)">Self-Issued Consulting</organization>
    </author>
    <author fullname="Edmund Jay" initials="E." surname="Jay">
      <organization abbrev="Illumila">Illumila</organization>
    </author>
    <date day="15" month="December" year="2023"/>
  </front>
</reference>

<reference anchor="OpenID.Registration" target="https://openid.net/specs/openid-connect-registration-1_0.html">
  <front>
    <title>OpenID Connect Dynamic Client Registration 1.0</title>
    <author fullname="Nat Sakimura" initials="N." surname="Sakimura">
      <organization abbrev="NAT.Consulting (was at NRI)">NAT.Consulting</organization>
    </author>
    <author fullname="John Bradley" initials="J." surname="Bradley">
      <organization abbrev="Yubico (was at Ping Identity)">Yubico</organization>
    </author>
    <author fullname="Michael B. Jones" initials="M.B." surname="Jones">
      <organization abbrev="Self-Issued Consulting (was at Microsoft)">Self-Issued Consulting</organization>
    </author>
    <date day="15" month="December" year="2023"/>
  </front>
</reference>

<reference anchor="OpenID.Federation" target="https://openid.net/specs/openid-federation-1_0.html">
  <front>
    <title>OpenID Federation 1.0</title>
    <author fullname="Roland Hedberg">
      <organization>independent</organization>
    </author>
    <author fullname="Michael B. Jones">
      <organization>Self-Issued Consulting</organization>
    </author>
    <author fullname="A. Solberg">
      <organization>Sikt</organization>
    </author>
    <author fullname="John Bradley">
      <organization>Yubico</organization>
    </author>
    <author fullname="Giuseppe De Marco">
      <organization>independent</organization>
    </author>
    <author fullname="Vladimir Dzhuvinov">
      <organization>Connect2id</organization>
    </author>
    <date day="4" month="December" year="2025"/>
  </front>
</reference>

<reference anchor="OpenID.RP.Choices" target="https://openid.net/specs/openid-connect-rp-metadata-choices-1_0.html">
  <front>
    <title>OpenID Connect Relying Party Metadata Choices 1.0</title>
    <author fullname="Michael B. Jones">
      <organization>Self-Issued Consulting</organization>
    </author>    
    <author fullname="R. Hedberg">
      <organization>independent</organization>
    </author>
    <author fullname="John Bradley">
      <organization>Yubico</organization>
    </author>
    <author fullname="F. Skokan">
      <organization>Okta</organization>
    </author>
    <date day="8" month="January" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation.Hosting" target="https://www.oidc.se/openid-federation-hosting/main.html">
  <front>
    <title>OpenID Federation Entity Configuration Hosting 1.0</title>
    <author fullname="Martin Lindström">
      <organization>IDsec Solutions</organization>
    </author>    
    <author fullname="Stefan Santesson">
      <organization>IDsec Solutions</organization>
    </author>
    <date day="9" month="January" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation.RegPolicy" target="https://www.oidc.se/openid-federation-registration-policy/main.html">
  <front>
    <title>OpenID Federation Registration Policy 1.0</title>
    <author fullname="Martin Lindström">
      <organization>IDsec Solutions</organization>
    </author>    
    <author fullname="Stefan Santesson">
      <organization>IDsec Solutions</organization>
    </author>
    <date day="12" month="January" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation.OrgId" target="https://www.oidc.se/openid-federation-organization-identifier/main.html">
  <front>
    <title>OpenID Federation Organization Identifier Metadata Parameter 1.0</title>
    <author fullname="Michael B. Jones">
      <organization>Self-Issued Consulting</organization>
    </author>    
    <author fullname="Martin Lindström">
      <organization>IDsec Solutions</organization>
    </author>    
    <author fullname="Stefan Santesson">
      <organization>IDsec Solutions</organization>
    </author>
    <date day="12" month="January" year="2026"/>
  </front>
</reference>


# Notices

Copyright (c) 2026 OpenID Connect Sweden.

# Document History

   [[ To be removed from the final specification ]]

   -00 

   *  Initial version
