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
: <br>An Entity within the federation that fulfils a protocol role, such as an OpenID Provider, OpenID Connect Relying Party, OAuth 2.0 Authorization Server, OAuth 2.0 Client, or OAuth 2.0 Protected Resource. This is typically a Leaf Entity.<br>

Federation Service Entity
: <br>An Entity within the federation that does not play a protocol role but instead takes on an operational role within the federation, such as a Trust Anchor, an Intermediate Entity, or a Trust Mark Issuer.<br>

Federation Registration Entity
: <br>A Superior Entity within the federation with which a Federation Protocol Entity (for example, an OpenID Connect Relying Party) registers to join the federation. This involves the collection of Entity Configuration and metadata, and the creation of an Entity Statement.<br>

Federation Resolver
: <br>A Federation Service Entity that provides functionality for obtaining Resolved Metadata and Trust Marks for a given Entity.

# Structuring Federation Deployments {#structuring_federation_deployments}

The OpenID Federation standard [@!OpenID.Federation], is generic and imposes few restrictions on how a federation may be structured. This section introduces a set of requirements and recommendations intended to make OpenID Federation deployments straightforward and easy to maintain.

## Responsibilities of a Federation Operator {#responsibilities_of_a_federation_operator}

This section describes the responsibilities of a Federation Operator, as manifested by a Trust Anchor, when establishing and operating a federation.

A Federation Operator **MUST** define Federation Rules that govern the operation of the federation and the conduct of its members. These rules encompass both technical requirements and non-technical processes. The following requirements apply to Federation Rules:

- A Federation Operator **MUST** define rules and requirements for joining the federation. It is **RECOMMENDED** that Registration Policies are defined; see (#use_of_registration_policies).

- A Federation Operator **SHOULD** define protocol-specific requirements, including which underlying standards and profiles federation members are required to comply with. This includes interoperability requirements such as regulated algorithm support and requirements for Entity metadata. See (#adapting_oauth_2_0_and_openid_connect_for_openid_federation), (#adapting_oauth_2_0_and_openid_connect_for_openid_federation, use title).

- A Federation Operator **SHOULD** define and maintain a Trust Mark Policy. See (#trust_mark_policy).

- It is **RECOMMENDED** that the Federation Operator defines federation-wide security requirements, such as minimum key lengths, key rollover frequency, and client authentication requirements.

- A Federation Operator **SHOULD** define recommended validity periods for Entity Statements in order to promote predictable behaviour and operational stability; see (#entity_statement_validity).

- A Federation Operator **SHOULD** define a base URL, or domain, for the federation. This base URL **SHOULD** be used when defining collision-resistant URLs within the federation context, such as Trust Mark type identifiers.

Some of the above rules are enforced through metadata policies or constraints, while others are enforced by operational means such as audits and controls.

## Federation Entity Types {#federation_entity_types}

[@!OpenID.Federation] does not restrict how federation roles may be combined by a Federation Entity operating under a single Entity Identifier. However, combining the role of an Intermediate Entity with that of a Federation Protocol Entity, such as an OpenID Provider, can introduce challenges and unnecessary complexity. Most importantly, it may lead to conflicts between the contents of the `metadata` Claim and the `metadata_policy` Claim in subordinate Entity Statements.

Therefore, implementers of this profile **MUST NOT** combine the role of a Trust Anchor, Intermediate Entity, Trust Mark Issuer, or Federation Resolver with that of a Federation Protocol Entity under the same Entity Identifier.

This requirement implies that a Federation Protocol Entity is always a Leaf Entity and that its Entity Configuration **MUST NOT** include metadata of type `federation_entity`.

## Federation Resolvers {#federation_resolvers}

[@!OpenID.Federation, section 10] specifies requirements for how an Entity resolves the Trust Chain and metadata of another Entity with which it wishes to establish trust. This process includes fetching Entity Statements, applying metadata policies and constraints, validating Trust Chains, and handling caching. The procedure is complex and may be difficult for all Federation Protocol Entities within the federation to implement. 

Also, this algorithm relies on all participants publishing their Entity Configuration information at a well-known location, as specified in [@!OpenID.Federation, section 9]. However, this profile references an alternative way of publishing Entity Configuration (see (#hosted_entity_configurations) below), that requires a chain building algorithm starting with a Trust Anchor instead of the bottom-up approach specified in [@!OpenID.Federation, section 10].

Therefore, it is **RECOMMENDED** that Entities compliant with this profile use a Federation Resolver in order to resolve metadata and trust for peer Entities. A Federation Resolver is an Entity within the federation that provides a `federation_resolve_endpoint` as specified in Sections [@!OpenID.Federation, 5.1.1] and [@!OpenID.Federation, 8.3] of [@!OpenID.Federation].

A Trust Anchor adhering to this profile **MUST** ensure the availability of at least one Federation Resolver compliant with the requirements stated in this profile. This resolver **MUST** support resolving for the given Trust Anchor. It is **RECOMMENDED** that the resolver is provided as part of the Trust Anchor itself.

A> If the resolver is provided by a Subordinate Entity to the Trust Anchor, federation participants that entirely relies on the use of the resolver will have to configure two trusted federation keys; both to the Trust Anchor and to the Entity implementing the Federation Resolver. See [@!OpenID.Federation, section 8.3.3].

(#resolving_metadata_and_trust_marks), (#resolving_metadata_and_trust_marks, use title), specifies further requirements for Federation Resolver usage and implementation. 

## Entity Statements {#entity_statements}

This section defines requirements and recommendations for Entity Statements defined in [@!OpenID.Federation, section 3].

### Entity Statement Validity {#entity_statement_validity}

The validity period of an Entity Statement is controlled by the `exp` Claim. Setting a short validity period undermines effective caching and places a burden on the issuing Entity to continuously update and sign the Entity Statement. Conversely, setting long validity periods for Entity Configurations may delay the propagation of metadata changes, as older versions may remain cached.

Federation rules **SHOULD** define recommended validity periods for Entity Statements in order to promote predictable behaviour and operational stability. In particular, Federation Operators are responsible for establishing guidance on appropriate validity intervals for Entities within their federation, see (#responsibilities_of_a_federation_operator).

An Entity **MUST** publish updated Entity Configurations at intervals shorter than the validity period indicated by the `exp` Claim. This ensures that a fresh Entity Configuration is available before the previously issued one expires, thereby increasing resilience in case of temporary outages, signing key rollover, or operational disruptions. Entities **SHOULD** publish updated Entity Configurations with sufficient margin to account for caching behaviour and clock skew.

If Trust Marks with short validity periods are used, these may effectively limit the usable validity of an Entity Configuration, see (#requirements_on_trust_mark_issuers). Therefore, federation operators **SHOULD** ensure that Trust Mark Issuers within the federation comply with the Trust Mark validity requirements stated in (#requirements_on_trust_mark_issuers).

### Hosted Entity Configurations {#hosted_entity_configurations}

The specification "OpenID Federation Entity Configuration Hosting" [@!OpenID.Federation.Hosting] defines the Entity Statement extension Claim `ec_location`. The primary purpose of this Claim is to enable hosting of a Leaf Entity's Entity Configuration data at an alternate location from that specified in [@!OpenID.Federation, section 9].

Using this Claim, an OpenID Federation deployment can allow Entities that do not support the [@!OpenID.Federation] standard, or that for other reasons cannot meet its requirements for publishing Entity Configuration at a well-known location, to participate in the federation.

For deployments adhering to this profile it is **RECOMMENDED** that the `ec_location` extension Claim is supported. Furthermore, it is **RECOMMENDED** that Superior Entities supporting the Claim include the Claim in all published Entity Statements, even if the subject's Entity Configuration is published at the well-known location as specified in [@!OpenID.Federation]. The reason for this is to offer a uniform way for resolvers to locate the subject Entity Configuration.

## Controlling Metadata for Subordinates {#controlling_metadata_for_subordinates}

A Superior Entity can control the resolved metadata of a Subordinate Entity either by assigning metadata values under the `metadata` Claim in a Subordinate Statement, or by using the `metadata_policy` Claim as defined in [@!OpenID.Federation, section 6.1]. In the latter case, the policy applies to all Entities that are Subordinates of the Entity that sets the policy.

This section specifies requirements and recommendations for metadata control in order to prevent unpredictable behaviour and to avoid metadata merge conflicts when chaining across federation contexts.

An Entity's Entity Configuration contains a `metadata` Claim in which the Entity declares parameters describing its preferences and capabilities. A metadata policy, as specified in Section 6.1 of [@!OpenID.Federation], may be included in Subordinate Statements to modify the metadata declared by an Entity.

Since any Entity in a Trust Chain that issues Subordinate Statements may define metadata policies, the effective metadata of an Entity is the result of merging all applicable policies along the chain. If a policy introduces parameter values that were not originally declared by the Entity, the resolved metadata may include capabilities or preferences that the Entity does not support. This can lead to unpredictable or invalid configurations.

Furthermore, merging multiple metadata policies in a Trust Chain may lead to merge conflicts, making it impossible to validate the metadata through that chain in a meaningful way. The risk of such conflicts increases when complex policies are defined by lower-level Entities in the chain.

This profile therefore specifies the following requirements:

- Adding metadata parameter values to an Entity's metadata SHOULD be limited to the Entity itself and its Immediate Superior Entity responsible for registering the Entity in the federation.

- An Immediate Superior Entity that needs to add metadata parameter values to an Entity's resolved metadata SHOULD declare these values directly in the `metadata` Claim of the Entity Statement issued for the Entity, and SHOULD NOT use metadata policy operators for this purpose.

Metadata policies **SHOULD** be used to constrain, filter, or refine metadata values declared by the Entity, and **SHOULD NOT** be used to introduce capabilities or preferences that are unknown to the Entity.

Metadata parameters can broadly be divided into two categories:

- Descriptive parameters that characterise the Entity, such as display name, logotype, and organizational affiliation.

- Protocol parameters that define security and functional settings, such as keys, algorithms, and endpoint URLs.

Deployments compliant with this profile SHOULD concentrate metadata policies that control security and functional settings at Trust Anchors.

Adhering to this requirement, together with the requirement in (#chaining_models) that Federation Protocol Entities are not chained directly under a Trust Anchor, enables the construction of alternative trust paths towards other Trust Anchors without requiring the application of multiple Trust Anchor metadata policies. This reduces the risk of merge conflicts caused by incompatible policies.


## Federation Hierarchy Requirements and Recommendations {#federation_hierarchy_requirements_and_recommendations}

[@!OpenID.Federation] defines an infrastructure in which multiple federation contexts may co-exist without clear boundaries between them. Each federation context is anchored by a common Trust Anchor. A Trust Anchor defines a policy that all subordinate services must satisfy in order for their metadata to be validated through that Trust Anchor.

A Federation Protocol Entity or Federation Service Entity may chain to more than one Trust Anchor. Chaining to a Trust Anchor does not, however, guarantee successful validation. Validation succeeds only if the Federation Protocol Entity's metadata conforms to the combined metadata policies of all Entities in the Trust Chain up to and including the Trust Anchor.

It is therefore important to structure the hierarchy of Federation Service Entities and their metadata policies carefully. The aim is to enforce essential rules while avoiding the unintended blocking of legitimate services due to incompatible policy applications.

This section contains sub-sections with requirements and recommendations for structuring a federation hierarchy in order to avoid unnecessary complexity and pitfalls.

### Chaining Models {#chaining_models}

Federation Protocol Entities **SHOULD NOT** be chained directly under a Trust Anchor. Instead, they **SHOULD** be chained to an Intermediate Entity (that is chained to the Trust Anchor). This requirement enables chaining a Federation Protocol Entity to other federation contexts, that is a chain ending at a different Trust Anchor, without the risk of metadata policy conflicts as described above.

It is also **RECOMMENDED** that Federation Protocol Entities that need to be available under a common Trust Anchor chain to a common Intermediate Entity. This makes it easier for that Trust Anchor to create a chain to groups of Federation Protocol Entities by creating a single chain link to the common Intermediate Entity.

A Trust Anchor **SHOULD NOT** be chained directly to another Trust Anchor in order to minimise risks of merge conflicts between Trust Anchor metadata policies.

### Trust Anchor and Trust Mark Issuer Roles {#trust_anchor_and_trust_mark_issuer_roles}

Trust Anchors may apply different metadata policies to the same Entity. That is, one Trust Anchor may restrict the set of metadata preferences in one way, while another imposes a different and potentially incompatible set of restrictions. When these policies cannot be reconciled into a single combined policy, a Trust Anchor that wants to support Entities recognised by another Trust Anchor must chain directly to a Subordinate Entity under that other Trust Anchor rather than chaining to the other Trust Anchor itself. See (#chaining_models) above.

However, this approach is no longer viable when the other Trust Anchor also operates as a Trust Mark Issuer whose Trust Marks are required to be understood by all Entities. Chaining to a Subordinate Entity bypasses the Trust Anchor role and therefore excludes trust in the Trust Mark Issuer. Attempting to resolve this by chaining directly to the Trust Mark Issuer is also problematic because such chaining implicitly creates an additional path through the other Trust Anchor, resulting in two possible trust paths, one of which may fail due to policy conflicts.

These issues are inherently difficult to resolve and introduce ambiguity and inconsistency in the trust path evaluation process. Therefore, deployments compliant with this profile **SHOULD NOT** allow Trust Anchors to also function as Trust Mark Issuers.

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

If the Federation Registration Entity includes metadata values in Subordinate Statements, these values **SHOULD** be limited to fixing descriptive Entity metadata that was controlled during registration. Typically, such values include display names or organizational affiliation. Constraining other metadata values is the responsibility of the Trust Anchor, see (#controlling_metadata_for_subordinates).

An Intermediate Entity acting as a Federation Registration Entity and compliant with this profile **MUST** expose a subordinate listing endpoint as defined in [@!OpenID.Federation, section 8.2].

## Use of Registration Policies {#use_of_registration_policies}

A Federation Registration Entity that creates a Subordinate Statement for an Entity follows a set of rules, described by a Registration Policy, during the registration process. Such rules may comprise:

- Checks to ensure that the organization behind the Entity has entered into the required agreements necessary for federation membership.

- Checks to ensure that the individual requesting that the Entity be added to the federation is authorized to do so, for example by validating that the person is authorized to represent the organization that owns the Entity. This may also involve requirements on the authentication strength for the Entity administrator.

- Checks to determine the ownership of domains. This is especially important when Entity Configuration Hosting is supported, see [@!OpenID.Federation.Hosting, section 4.1].

- Assertions that Entity informational metadata parameters such as `organization_name` and `display_name` contain values that correspond to the organization behind the Entity.

It is **RECOMMENDED** that federation deployments compliant with this profile define Registration Policy URIs for the policies that are used for registering Entities, and that Federation Registration Entities include the `registration_policy` Claim as defined by [@!OpenID.Federation.RegPolicy].

**Note**: A Trust Mark could in theory be used to represent that a certain policy was applied during registration of an Entity to the federation. However, there is an important distinction between Registration Policies and Trust Marks. Whether an Entity holds a particular Trust Mark is typically checked by other Entities after its metadata and Trust Marks have been resolved and validated. Registration Policies, on the other hand, operate as part of the Trust Chain building process and are enforced through constraints defined by the federation. 

# Resolving Metadata and Trust Marks {#resolving_metadata_and_trust_marks}

As described in (#federation_resolvers), this profile recommends the use of Federation Resolvers to resolve peer metadata and Trust Marks. This section defines requirements and recommendations for both Entities implementing a Federation Resolver and Entities using a Federation Resolver.

## Federation Resolver Requirements {#federation_resolver_requirements}

A Trust Anchor or an Intermediate Entity that provides a `federation_resolve_endpoint` is regarded to be a Federation Resolver. 

This section extends the requirements specified in [@!OpenID.Federation, section 8.3] with the following statements:

A Federation Resolver **MAY** include Trust Marks that are not present in an Entity's Entity Configuration. It can do so by communicating directly with a Trust Mark Issuer. This functionality may be useful in cases when Trust Marks are being used a control mechanism within the federation and Entities within the federation are unaware of a particular Trust Mark type.

The requirements for the resolve response `exp` Claim given in [@!OpenID.Federation, section 8.3.2] states that the validity of the response must not exceed the validities of the underlying Trust Chain and Trust Marks included. If a Trust Mark instance for the Entity is being resolved is either expired, or has a validity that is shorter than the validity of the Trust Chain, it is **RECOMMENDED** that the resolver obtains a new Trust Mark instance for the Entity by calling the Trust Mark endpoint at the Trust Mark Issuer.

By following this requirement, the Federation Resolver avoids issuing resolve responses with unnecessarily short validity periods. This reduces the frequency of resolve requests, as longer-lived responses are more amenable to caching by consuming parties.

## Using a Federation Resolver {#using_a_federation_resolver}

The resolve endpoint, request and response formats are defined in [@!OpenID.Federation, section 8.3].

### Sending a Resolve Request {#sending_a_resolve_request}

An Entity wishing to obtain the resolved metadata and Trust Marks of a peer Entity sends a resolve request to the `federation_resolve_endpoint` of a trusted Federation Resolver, as described in [@!OpenID.Federation, section 8.3.1].

If the caller has prior knowledge of the Trust Anchor under which the subject Entity is registered, it **MUST** include only that Trust Anchor in the `trust_anchor` parameter. Including additional Trust Anchor values when the correct one is already known introduces unnecessary ambiguity and **SHOULD NOT** be done. The `trust_anchor` parameter may be specified multiple times only when the caller genuinely does not know under which Trust Anchor the subject is registered and wishes to delegate that determination to the resolver.

### Processing the Resolve Response {#processing_the_resolve_response}

If the Federation Resolver is not implemented by the Trust Anchor itself, the caller may need to explicitly configure trust in the resolver. See (#federation_resolvers) for requirements on how Trust Anchors ensure resolver availability and on configuring trust for resolvers that are not hosted by a Trust Anchor.

A consumer **MUST NOT** use a resolve response beyond its validity period as indicated by the `exp` Claim of the response JWT. The `exp` value reflects the shortest validity among the underlying Trust Chain and any included Trust Marks.

Implementations **SHOULD** implement caching of resolve responses. A cached response **MAY** be reused for subsequent requests for the same subject and trust context, that is, the same combination of subject Entity Identifier and Trust Anchor, provided the response has not yet expired. This reduces the frequency of calls to the Federation Resolver and improves overall federation performance.

Although the resolve response includes the Trust Chain in the `trust_chain` Claim as required by [@!OpenID.Federation, section 8.3.2], most consumers resolving peer metadata for the purpose of establishing protocol-level trust do not need to process or validate the Trust Chain themselves, as the Federation Resolver has already performed this validation. Such consumers **MAY** ignore the `trust_chain` Claim in the resolve response.

# Trust Marks {#trust_marks}

## Trust Mark Policy {#trust_mark_policy}

A Federation Operator **SHOULD** define a Trust Mark Policy for the federation. The Trust Mark Policy **MUST** define:

- Rules and processes for designating which actors may act as federation-accredited Trust Mark Issuers.

- Rules and requirements applicable to federation-accredited Trust Mark Issuers. The requirements stated in (#requirements_on_trust_mark_issuers) apply, but the policy may define additional requirements, such as the authorization criteria that determine whether a Trust Mark can be issued to a given Entity.

- Rules and processes for defining Trust Mark types recognized by the federation, including which Trust Mark Issuer(s) may issue each Trust Mark type.

- The URL identifiers for Trust Mark types recognized within the federation.<br /><br />Note: The definition of these identifiers cannot be delegated to Trust Mark Issuers, since it is the responsibility of the Federation Operator to ensure that they are collision-resistant across multiple federations, see [@!OpenID.Federation, section 7.1].

- Whether Trust Mark Issuers may issue Trust Mark types that are not recognized federation-wide, for example Trust Marks intended for specific purposes or specific Entity audiences.

A Trust Mark Policy **MAY** also define rules or recommendations for the validation of Trust Marks, see [@!OpenID.Federation, section 7.3]. If validation rules are defined, it is **RECOMMENDED** that these also cover requirements for Trust Mark status checking.  

**Note**: Only a federation-accredited Trust Mark Issuer is allowed to issue Trust Mark types that are recognized by the federation. A Trust Mark Issuer is considered federation-accredited when it appears in the `trust_mark_issuers` Claim of the Trust Anchor's Entity Configuration, as defined in [@!OpenID.Federation, section 7]. This Claim also identifies which Trust Mark types are recognized by the federation, and which Trust Mark Issuers are authorized to issue each type.

## Requirements on Trust Mark Issuers {#requirements_on_trust_mark_issuers}

A Federation Service Entity that exposes a Trust Mark endpoint as defined in [@!OpenID.Federation, section 8.3.3], is a Trust Mark Issuer.

A Trust Mark Issuer wishing to issue Trust Marks that should be recognized within the federation 
**MUST** coordinate with, and apply at, the Federation Operator (Trust Anchor) to have both the Trust Mark Issuer and the Trust Mark type listed in Trust Anchor's `trust_mark_issuers` Entity Configuration Claim. In these cases, it is the responsibility of the Federation Operator to define the Trust Mark type identifier to be used.

The Trust Mark Issuer is responsible for maintaining a repository of the Entities that are entitled to specific Trust Mark types, including the authorizations and limitations that apply to them. The procedures by which an Entity applies for a Trust Mark, and the procedures used to determine whether a Trust Mark is granted, are outside the scope of this profile.

If short-lived Trust Mark instances, that is, JWTs with an `exp` Claim set to a near-term time, are issued, this affects the validity of Entity Configurations that include such Trust Marks. Consequently, the validity period of resolve responses issued by a Federation Resolver may also need to be reduced.

The practical consequences include the following:

- Leaf Entities have to obtain new Trust Mark instances frequently and update and re-sign their Entity Configurations accordingly.

- Federation Resolvers will be required to issue resolve responses with short validity periods, since a resolve response cannot exceed the validity of the artefacts it contains, see [@!OpenID.Federation, section 8.3.2]. This limits the ability to cache resolve responses within the federation and increases the number of invocations to Federation Resolvers.

Therefore, the following requirements apply to Trust Mark Issuers that are compliant with this profile:

- The validity period of a Trust Mark JWT **SHOULD** be aligned with the validity of the underlying authorization that determines the Entity’s entitlement to the Trust Mark. If that authorization is not time-limited, the Trust Mark Issuer **SHOULD NOT** include an `exp` Claim in the Trust Mark JWT.

- A Trust Mark Issuer **MUST** expose a Trust Mark Status endpoint, as defined in [@!OpenID.Federation, section 8.4]. This is required because the use of long-lived Trust Mark instances needs to be combined with status checking, that is, verifying that the Trust Mark privileges for the holder have not been revoked.

A Federation Service Entity can choose to require client authentication for its federation endpoints. 

When a Trust Mark Issuer deployment is configured to require client authentication for its Trust Mark endpoint, see [@!OpenID.Federation, section 8.6], the Federation Operator **SHOULD** be consulted to obtain information about which Entities are permitted to request a Trust Mark on behalf of another Entity. Typically, these are Federation Resolvers that retrieve a subject’s Trust Marks as part of the resolve process, see (#federation_resolver_requirements), (#federation_resolver_requirements, use title), or an Intermediate Entity acting as a Federation Registration Entity that retrieves Trust Marks on behalf of Entities being registered.

# Federation Algorithm Requirements {#federation_algorithm_requirements}

Within an OpenID Federation deployment, each Entity has at least one federation key. An Entity's federation key is used when signing its Entity Statement, see [@!OpenID.Federation, section 3], and a Federation Service Entity also uses its federation key to sign responses and objects returned from federation endpoints, see [@!OpenID.Federation, section 8].

To ensure interoperability at the algorithm level for federation operations, this profile mandates a common set of signature algorithms that all compliant Entities **MUST** support for signature validation. These algorithms are:

- `RS256`, RSASSA-PKCS1-v1_5 using SHA-256, as defined in [@!RFC7518, section 3.3].

- `RS384`, RSASSA-PKCS1-v1_5 using SHA-384, as defined in [@!RFC7518, section 3.3].

- `RS512`, RSASSA-PKCS1-v1_5 using SHA-512, as defined in [@!RFC7518, section 3.3].

- `ES256`, ECDSA using P-256 and SHA-256, as defined in [@!RFC7518, section 3.4].

- `ES384`, ECDSA using P-384 and SHA-384, as defined in [@!RFC7518, section 3.4].

- `ES512`, ECDSA using P-521 and SHA-512, as defined in [@!RFC7518, section 3.4].

Additional signature algorithms, such as RSASSA-PSS, **MAY** be added to the above list by profiles or federation rules that extend this profile.

If a Federation Service Entity requires client authentication using `private_key_jwt` at any of its federation endpoints, see [@!OpenID.Federation, section 8.8.1], the `endpoint_auth_signing_alg_values_supported` metadata parameter **MUST** be assigned the list of mandatory signature algorithms, see [@!OpenID.Federation, section 5.1.1].

# Adapting OAuth 2.0 and OpenID Connect for OpenID Federation {#adapting_oauth_2_0_and_openid_connect_for_openid_federation}

This document is a profile for OpenID Federation and should refrain from introducing protocol-specific requirements for the use of OAuth 2.0 and OpenID Connect — such requirements should be addressed in protocol-specific standards and profiles.

However, OAuth 2.0 and OpenID Connect predate the introduction of OpenID Federation, and some concepts of these protocols do not mix naturally with a federated environment.

Both OAuth 2.0 and OpenID Connect assume that there is a registration phase where the client (an OAuth 2.0 Client or OpenID Connect Relying Party) registers at the server (an OAuth 2.0 Authorization Server or OpenID Connect OpenID Provider), and the parameters needed for future protocol exchanges are negotiated based on the server's capabilities and policies and the client's requirements. The client metadata returned in a registration response therefore reflects what has been approved by the Authorization Server or OpenID Provider.

In an OpenID Federation context, the client instead presents its metadata to the federation, and the server consumes that metadata after resolving the client's Entity Statement. While [@!OpenID.Federation, section 12] defines methods for registering a Relying Party at an OpenID Provider, the metadata made available to the federation still needs to be generic, since it will presumably be consumed by multiple OpenID Providers and Authorization Servers.

This section provides requirements for the use of OAuth 2.0 and OpenID Connect in an OpenID Federation context.

## Algorithm Support {#algorithm_support}

In both OAuth 2.0 and OpenID Connect, a client or Relying Party declares **one** algorithm in its registration data for each specific usage. For example, `token_endpoint_auth_signing_alg` [@!OpenID.Registration] declares which signature algorithm a Relying Party uses when signing a JWT for authentication at the OpenID Provider token endpoint. The Relying Party selects a suitable algorithm based on the `token_endpoint_auth_signing_alg_values_supported` in the OpenID Provider's Discovery Document [@!OpenID.Discovery].

In a federation, where a client's metadata may be consumed by several peers, this approach breaks down, since different servers (Authorization Servers or OpenID Providers) may support different sets of algorithms, and the intersection of those sets may be empty.

"OpenID Connect Relying Party Metadata Choices 1.0" [@!OpenID.RP.Choices] attempts to solve this problem by introducing metadata parameters through which a Relying Party can declare which algorithms it supports, allowing the OpenID Provider to use these values during client registration. This approach works in deployments where all Relying Parties and all OpenID Providers fully support that specification.

However, this profile does not impose such requirements. Instead, it specifies a set of algorithms that are mandatory to support. This ensures that legacy systems that are not fully OpenID Federation-compliant can still function within the federation.

OAuth 2.0 Clients, OAuth 2.0 Authorization Servers, OpenID Connect Relying Parties, and OpenID Connect OpenID Providers compliant with this profile **MUST** adhere to the algorithm requirements specified below.

All compliant Entities **MUST** support validation of signatures using any of the following algorithms:

- `RS256`, RSASSA-PKCS1-v1_5 using SHA-256, as defined in [@!RFC7518, section 3.3].
- `RS384`, RSASSA-PKCS1-v1_5 using SHA-384, as defined in [@!RFC7518, section 3.3].
- `RS512`, RSASSA-PKCS1-v1_5 using SHA-512, as defined in [@!RFC7518, section 3.3].
- `ES256`, ECDSA using P-256 and SHA-256, as defined in [@!RFC7518, section 3.4].
- `ES384`, ECDSA using P-384 and SHA-384, as defined in [@!RFC7518, section 3.4].
- `ES512`, ECDSA using P-521 and SHA-512, as defined in [@!RFC7518, section 3.4].

All compliant Entities **MUST** support encryption using any of the following algorithms:

- `RSA-OAEP`, RSAES OAEP using default parameters, as defined in [@!RFC7518, section 4.3].
- `RSA-OAEP-256`, RSAES OAEP using SHA-256 and MGF1 with SHA-256, as defined in [@!RFC7518, section 4.3].
- `ECDH-ES`, ECDH Ephemeral Static direct key agreement, as defined in [@!RFC7518, section 4.6].

An Entity holding an RSA protocol key **MUST** support decryption using any of the following algorithms:

- `RSA-OAEP`, RSAES OAEP using default parameters, as defined in [@!RFC7518, section 4.3].
- `RSA-OAEP-256`, RSAES OAEP using SHA-256 and MGF1 with SHA-256, as defined in [@!RFC7518, section 4.3].

An Entity holding an EC protocol key **MUST** support decryption using the following algorithm:

- `ECDH-ES`, ECDH Ephemeral Static direct key agreement, as defined in [@!RFC7518, section 4.6].

Profiles extending this profile, or a Federation Operator's federation rules, **MAY** mandate additional algorithms to support.

## Client Authentication Methods {#client_authentication_methods}

Similarly to algorithms, the `token_endpoint_auth_method` parameter [@!RFC7591][@!OpenID.Registration] can only hold **one** value. In a federation, a single set of client metadata may be resolved and consumed by any number of servers. This may cause interoperability problems if two servers that the client needs to interact with have different and non-overlapping requirements for client authentication, as the client would be unable to satisfy both simultaneously.

It is **RECOMMENDED** that the Federation Operator defines requirements for which client authentication methods OAuth 2.0 Authorization Servers and OpenID Connect OpenID Providers should support, in order to avoid such interoperability problems. This can be done by referring to a specific profile, or by including such requirements in the federation rules. 

## Additional Considerations {#additional_considerations}

This section presents a non-exhaustive list of topics where a Federation Operator, or members of the federation, need to be aware of potential interoperability issues or semantic differences between non-federation OAuth 2.0 and OpenID Connect and their use within an OpenID Federation deployment.

Within OpenID Federation, resolved metadata for a client Entity is metadata produced by the client itself, possibly modified by metadata policies. It is therefore the client's self-declared metadata. In contrast, in a non-federation OAuth 2.0 or OpenID Connect deployment, client metadata is the result of a registration operation, and the metadata parameters have been approved and authorized by the Authorization Server or OpenID Provider. An Authorization Server or OpenID Provider functioning within an OpenID Federation deployment **MUST** be aware of this difference, and employ appropriate mechanisms when consuming client metadata obtained from the federation.

**OAuth 2.0 Scopes**: An Authorization Server declares its supported scopes using the `scopes_supported` parameter [@!RFC8414], and an OAuth 2.0 client's metadata may contain a `scope` parameter [@!RFC7591] listing the scopes it intends to use when requesting tokens. In a non-federation deployment, these scopes may have been authorized as part of the registration process (see above). In an OpenID Federation deployment, other mechanisms are needed to establish trust in such scope declarations.

Furthermore, in a peer-to-peer registration, any scopes referenced are in the context of that specific registration. In an OpenID Federation deployment, generic scope values such as `read` or `write` may be ambiguous, since a client may interact with multiple Authorization Servers. One approach to mitigating this is to use distinct scope values mapped to specific resources or functions.

**OpenID Connect Subject Types**: [@!OpenID.Registration, section 2] defines the `subject_type` metadata parameter, which is used by an OpenID Connect Relying Party to declare whether it requires subject identifiers in tokens to be `public` or `pairwise`. Correspondingly, an OpenID Provider's Discovery metadata contains the `subject_types_supported` parameter [@!OpenID.Discovery], listing the subject types the OpenID Provider supports. If OpenID Providers within the federation do not support both types, interoperability issues may arise. It is **RECOMMENDED** that the Federation Operator, via referenced profiles or federation rules, requires OpenID Providers to support both the `public` and `pairwise` subject types.

# Acknowledgments

We would like to thank the following individuals for their comments, ideas, and contributions to this implementation profile and to the initial set of implementations.

- Henric Norlander, Nod\[9\]

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
    <author initials="E." surname="Jay">
      <organization abbrev="Illumila">Illumila</organization>
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
    <date day="12" month="March" year="2026"/>
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
