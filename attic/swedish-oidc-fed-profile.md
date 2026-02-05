![Logo](img/oidc-logo.png)

# The Swedish OpenID Federation Profile

### Version: 1.0 - draft 06 - 2025-01-31

## Abstract

This specification defines a profile for OpenID Connect federations for use within the Swedish public and private sectors.
It profiles the OpenID Federation standard \[[OpenID.Federation](#openid-federation)\]
to provide a baseline for security and interoperability for metadata exchange between OAuth and OpenID entities.

## Table of Contents

1. [**Introduction**](#introduction)
   
   1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
   
   1.2. [Conformance](#conformance)
   
   1.3. [Definitions](#definitions)
2. [**Federation Structure**](#federation-structure)
   
   2.1. [Federation Entity Types](#federation-entity-types)
   
   2.2. [Resolvers](#resolvers)
   
   2.3. [Bridging federation contexts with separate Trust Anchors](#bridging-federation-contexts-with-separate-trust-anchors)
3. [**Entity Statements**](#entity-statements)
   
   3.1. [Subject Entity Configuration location claim](#subject-entity-configuration-location-claim)
4. [**Metadata**](#metadata)
5. [**Metadata Policy**](#metadata-policy)
   
   5.1. [Custom Policy Operators](#custom-policy-operators)
   
   5.2. [Policy Operator Constraints](#policy-operator-constraints)
6. [**Discovery endpoint**](#discovery-endpoint)
   
   6.1. [Federation Entity Metadata](#federation-entity-metadata)
   
   6.2. [Discovery Request](#discovery-request)
   
   6.3. [Discovery Response](#discovery-response)
7. [**Usage with OpenID Connect**](#usage-with-openid-connect)
   
   7.1. [OIDC Request Parameters](#oidc-request-parameters)
8. [**Normative References**](#normative-references)

---

<a name="introduction"></a>

## 1. Introduction

This specification defines a profile for OpenID Federation for use within the Swedish public and private sector based on the OpenID
Federation specification \[[OpenID.Federation](#openid-federation)\].

<a name="requirements-notation-and-conventions"></a>

### 1.1. Requirements Notation and Conventions

The keywords “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be
interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability
and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="conformance"></a>

### 1.2. Conformance

This profile defines a profile for the OpenID federation standard for use in OIDC Sweden.

When an entity compliant with this profile is interacting with other entities compliant with this profile, all entities MUST fully conform
to the features and requirements of this specification. Any interaction with entities that are not compliant with this profile is out of
scope for this specification.

<a name="definitions"></a>

### 1.3. Definitions

The following terms are used in this document to enhance readability:

| Term                           | Meaning                                                                                                                                                                                                                                                                                                                       |
| :----------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Federation service             | A defined OpenID Connect- or OAuth service such as OpenID providers (OP), OpenID relying parties (RP), OAuth Authorization Services (AS), OAuth clients (Client) and Resource Servers (RS).                                                                                                                                   |
| Federation node                | A Federation Entity that is not a Federation service, but serves as either Trust Anchor, Intermediate Entity, Trust Mark Issuer or Resolver.                                                                                                                                                                                  |
| federation service information | The data of a federation service that includes metadata and Trust Marks, but also information such as policy. federation service information is provided as an Entity Statement issued by a Federation Node for a subordinate entity or as Entity Configuration provided as a self signed statement by any federation entity. |

<a name="federation-structure"></a>

## 2. Federation Structure

<a name="federation-entity-types"></a>

### 2.1. Federation Entity Types

The OpenID federation standard does not limit how federation roles can be mixed by a federation entity acting under a single Entity Identifier. Mixing the role of an Intermediate Entity with a federation service role may, however, provide challenges and unnecessary complexity. Most importantly this may create conflicts between contents in the `metadata` claim and the `metadata_policy` claim in subordinate Entity Statements

Implementers of this profile MUST NOT provide the role of an Intermediate Entity, Trust Anchor, Trust Mark Issuer or Resolver combined with the provision of a federation service under the same EntityID.<a name="resolvers"></a>

<a name="resolvers"></a>

### 2.2. Resolvers

The Resolver is a Federation Entity that provides a `Resolve Entity Statement` endpoint.

This profile defines means for simplified registration of federation services. As federation services that use such simplified registration can only be discovered through a Resolver, the Resolvers are essential in this profile as a means to provide easy access to validated federation service information in a federation setup that allows simplified registration. Each Trust Anchor that supports simplified registration of federation services MUST ensure the availability of at least one Resolver, compliant with this profile. A Resolver supported by a Trust Anchor MUST be provided by the Trust Anchor or chain to the Trust Anchor.

Resolvers compliant with this profile MUST provide a discovery endpoint as defined in [section 5](#discovery-endpoint) and MUST support the `subject-entity-configuration-location` Entity Statement claim defined in [section 3.1](#subject-entity-configuration-location-claim).

<a name="bridging-federation-contexts-with-separate-trust-anchors"></a>

### 2.3. Bridging federation contexts with separate Trust Anchors

The OpenID federation defines an infrastructure where different federation contexts may co-exist and where there no longer exist distinct borders between what belongs to each federation context.

Each federation context is enforced through a common Trust Anchor where a Trust Anchor defines a policy that all subordinate services must be compatible with to be validated through this Trust Anchor.

Any federation service or federation node may chain to more than one Trust Anchor. Chaining to a Trust Anchor does, however, not guarante that the federation metadata can be validated through that Trust Anchor. Successful validation of federation service metadata requires that the federation service metadata conform to the combined metadata policy of the chain of entities up to and including the Trust Anchor.

It is therefore important to structure the hierarchy of federation nodes and their metadata policies carefully to both enforce essential rules, but still avoid blocking of legitimate services due to incompatible policy applications.

The following aspects SHOULD be taken into consideration:

**Concentrate metadata policy expression at Trust Anchors**

Merge of metadata policies in a trust chain may lead to merge conflicts, making it impossible to validate metadata through that chain in any meaningful way. The risk of problems increases if complex policies are defined by lower entities in the chain. Federation architectures should therefore concentrate policy expression on each TA and only express metadata policy at the level of an Intermediate Entity if this is considered necessary. The Concentration of metadata policies to the Trust Anchor level makes it easier to construct an alternative path to multiple Trust Anchors without having to merge policies of different Trust Anchors, thus avoiding merge errors caused by incompatible policies.

**Consolidate common services**

Federation chaining can be optimised considerably if federation services that need to be available under a common Trust Anchor, also chains to a common Intermediate entity. This makes it easier for that Trust Anchor to crate a chain to groups of federation services by crating a single chain link to the common Intermediate Entity.

**Avoid federation services directly under a Trust Anchor**

Federation services SHOULD always be chained to an Intermediate Entity and SHOULD NOT be chained directly under a Trust Anchor. Following this rule makes it possible for other Trust Anchors to chain to the federation service via the Intermediate Entity rather than either directly to the federation service or via the other Trust Anchor.

**Avoid chaining a Trust Anchor under another Trust Anchor**

Chaining a Trust Anchor to another Trust Anchor should be avoided to minimise the risk of policy merge conflicts between the different Trust Anchor metadata policies.

<a name="entity-statements"></a>

## 3. Entity Statements

<a name="subject-entity-configuration-location-claim"></a>

### 3.1. Subject entity configuration location claim

This section defines the `subject_entity_configuration_location` claim for inclusion in Entity Statements.

The `subject_entity_configuration_location` claim provide information about subject publication of its Entity Configuration data.

This claim holds a single string value, specifying the URL where the subject Entity Configuration is available. The full Entity Configuration data MAY be embedded in this claim by using the "data" URL scheme \[[RFC2397](#rfc2397)\].

When data URL is used the media type MUST be specified as `application/entity-statement+jwt`, the optional `;base64` declaration MUST be omitted and the EntityConfiguration data MUST be provided as a JWS using compact serialization.

**Note:** The reason for omitting `;base64` is that this is both wrong and redundant for this purpose. It is wrong as the JWS is not a string of base64 encoded data, but rather base64URL encoded fragments separated by "." characters. It is redundant because this format is already defined by the `application/entity-statement+jwt` mime type.

Example of embedded Entity Configuration using the data URL scheme:

> "subject_entity_configuration_location": "data:application/entity-statement+jwt,eyJhb...Qssw5c"

**Note:**
\[[OpenID.Federation](#openid-federation)\] (section 7)
provides two alternative locations for Entity Configuration data relative to the subject's Entity Identifier URL.
If the location specified by RFC8414 fails, data retrieval SHOULD be retried using the alternate location.
It is therefore RECOMMENDED to specify `location` also for the `well_known` publication type.
This enables Resolvers to identify the precise URL, thereby eliminating the need for multiple attempts to retrieve data from various URLs when performing top down discovery of services and their data.

<a name="metadata"></a>

## 4. Metadata

The metadata for federation services is specified in the Entity Configuration of that service under the metadata claim. The metadata claim holds metadata per entity type. An entity may support multiple roles by providing metadata for each supported role (e.g. an OpenID Relying Party may also provide the role of an OAuth Client). The OpenID federation standard allows common metadata parameters to be provided under the neutral entity type `federation_entity`.

Storing common metadata parameters for federation services under the common `federation_entity` introduces some challenges:

- It makes it more complex to assemble relevant metadata for a federation service from its Entity Configuration.
- Resolvers will not return the common `federation_entity` metadata content if the resolve request specifies a specific entity type that is not `federation_entity`.

Implementers of this profile MUST provide complete metadata for federation services under the entity type associated with this entity type.

Interaction with any federation service MUST NOT require obtaining the metadata specified for the `federation_entity` entity type.

<a name="metadata-policy"></a>

## 5. Metadata Policy

<a name="custom-policy-operators"></a>

### 5.1. Custom Policy Operators

This section defines additional metadata policy operators and their use in the policy merge process.

<a name="intersects"></a>

#### 5.1.1. Intersects

**Identifier:** `intersects`

**Logic:** The `intersects` policy operator is a value check that holds an array of values.
The value check is successful when the metadata parameter contains at least one of the values contained in the operator.
This value check does not alter any content in the metadata parameter.
The metadata parameter MAY contain any value not contained in the policy operator as long as at least one value matches with the policy
operator values.

**Merge processing:** The result of merging the values of two `intersects` operators is the intersection of the operator values.

<a name="regexp"></a>

#### 5.1.2. Regexp

**Identifier:** `regexp`

**Logic:** The `regexp` policy operator holds one or more regular expressions. When a single regular expression is provided, it MAY be provided as a single string value. The value check is successful if, and only if, all regular expressions match all values in the metadata parameter.

**Merge processing:** The result of merging the values of two `regexp` operators is the union of the operator values.

<a name="policy-operator-constraints"></a>

### 5.2. Policy Operator Constraints

Implementations compliant with this profile MUST NOT use policy operators that add any value to the target entity metadata parameter that has not been expressed by the target entity. This requirement ensures that no metadata value is present in the processed policy that has not been intentionally declared by the target entity. This means that the following policy operators defined in OpenID federation MUST NOT be used:

- value
- add
- default

**NOTE:** As an alternative to using the policy operators above, an Intermediate Entity can instead add explicit values in the
metadata claim in its Entity Statement issued for the target entity.

<a name="discovery-endpoint"></a>

## 6. Discovery Endpoint

The discovery endpoint is exposed by Federation Entities acting as a Resolver. This endpoint lists all entities that can be resolved through this resolver that matches the discovery request.

The primary purpose of this endpoint is to support discovery of services such as OpenID Providers, Authorization Servers and Resource servers, which normally makes up a fraction of all available services. Discovery requests that include requests for client services, such as OpenID Relying Parties and OAuth Clients, may result in a very large list.

Use of this endpoint SHOULD be used with caution when the federation includes a large population of entities. Resolvers MAY deny or rate limit requests for client services such as OpenID Relying Parties and OAuth Clients.

<a name="federation-entity-metadata"></a>

### 6.1. Federation Entity Metadata

This profile defines the `federation_discovery_endpoint` parameter to specify the location of a Resolver's discovery endpoint. A Resolver MUST publish its discovery endpoint location in its `federation_discovery_endpoint` metadata Entity Type using the `discovery_endpoint` parameter.

The discovery endpoint URL MUST use the https scheme and MAY contain port, path, and query parameter components encoded in application/x-www-form-urlencoded format. It MUST NOT contain a fragment component.

<a name="discovery-request"></a>

### 6.2. Discovery Request

The request MUST be an HTTP request using the GET method to a list endpoint with the query parameters,
encoded in application/x-www-form-urlencoded format, listed below.

The defined request parameters for a discovery request are:

| Parameter       | Requirement | Type | Description |
|:----------------| :-- | :-- | :-- |
| `trust_anchor`  |REQUIRED|Single value| The Trust Anchor the returned entities must resolve to.|
| `entity_type`          |OPTIONAL|One or more values | Specifies the requested entity types. An absent parameter is interpreted as all entity types.|
| `trust_mark_id` |OPTIONAL|One or more values|Specifies the Trust Mark identifiers that must be supported by an entity for this entity to be included in the response.|

The following is a non-normative example of an HTTP GET request for a list of subordinates:

```
GET /discovery HTTP/1.1
Host: openid.example.com?trust_anchor=https%3A%2F%2Fopenid.example.com%2FTA&entity_type=openid_provider
```

<a name="discovery-response"></a>

### 6.3. Discovery Response

A successful response MUST return HTTP status code 200 with the content type `application/json`,
containing a JSON array with the resolved Entity Identifiers matching the request.

If the response is negative, the response is as defined in section 8.8 of
\[[OpenID federation](#openid-federation)\].

The following is a non-normative example of a response containing the resolved Entities:

```
200 OK
Content-Type: application/json

[
"https://ntnu.andreas.labs.uninett.no/",
"https://blackboard.ntnu.no/openid/callback",
"https://serviceprovider.andreas.labs.uninett.no/application17"
]
```

<a name="usage-with-openid-connect"></a>

## 7. Usage with OpenID Connect

<a name="oidc-request-parameters"></a>

### 7.1. OIDC Request Parameters

Section 11 of \[[OpenID federation](#openid-federation)\] specifies the OPTIONAL inclusion of the
request parameter `trust_chain` in OIDC requests. The challenge with this request parameter is that
it imposes requirements on the receiving OP to check the consistency of its content.

This profile includes requirements for Resolvers as the source of validated federation service information,
making this `trust_chain` parameter obsolete. The OP is only expected to use this Resolver to obtain
trusted federation service information, including trusted and processed metadata, as well as trusted and
validated Trust Marks.

Implementations of this profile MUST NOT include the `trust_chain` parameter in OIDC requests. An OP
receiving a request that includes `trust_chain` parameter MAY choose to either respond with an error,
or to process the request according to the processing requirements specified in OpenID federation.

<a name="normative-references"></a>

## 8. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**

> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="rfc2397"></a>
**\[RFC2397\]**

> [Masinter, L., "The "data" URL scheme", RFC 2397, DOI 10.17487/RFC2397, August 1998](https://www.rfc-editor.org/info/rfc2397).

<a name="openid-federation"></a>
**\[OpenID.Federation\]**

> [R. Hedberg, M.B. Jones, A.Å. Solberg, J. Bradley, G. De Marco, V. Dzhuvinov "OpenID Federation 1.0 - draft 30"](https://openid.net/specs/openid-federation-1_0.html).

