![Logo](img/oidc-logo.png)

# The Swedish OpenID Federation - Profile

### Version: 0.1 - draft 01 - 2023-12-11

## Abstract

This specification defines a profile for OpenID Connect federations for use within the Swedish public and private sectors.
It profiles the OpenID Federation standard [[OpenID.Federation\]](#openid-federation)
to provide a baseline for security and interoperability for metadata exchange between OAuth and OpenID entities.

## Table of Contents

1. [**Introduction**](#introduction)

   1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

   1.2. [Conformance](#conformance)

   1.3. [Definitions](#definitions)

2. [**Federation Structure**](#federation-structure)

   2.1. [Federation Entity Types](#federation-entity-types)

   2.2. [Resolvers](#resolvers)

3. [**Metadata**](#metadata)

4. [**Metadata Policy**](#metadata-policy)

   4.1. [Custom policy operators](#custom-policy-operators)

   4.2. [No Merge Policy Operators](#no-merge-policy-operators)

   4.3. [Policy Operator Constraints](#policy-operator-constraints)

5. [**Discovery endpoint**](#discovery-endpoint)

   5.1. [Federation Entity metadata](#federation-entity-metadata)

   5.2. [Discovery request](#discovery-request)

   5.3. [Discovery response](#discovery-response)

6. [**Usage with OpenID Connect**](#usage-with-openid-connect)

   5.1. [OIDC request parameters](#oidc-request-parameters)

7. [**Security Requirements**](#security-requirements)

   7.1. [Cryptographic Algorithms](#cryptographic-algorithms)

8. [**Normative References**](#normative-references)

---

<a name="introduction"></a>
## 1. Introduction

This specification defines a profile for OpenID Federation for use within the Swedish public and private sector. It profiles the OpenID
Federation specification [[OpenID.Federation\]](#openid-federation) to:

1) Define how resolvers provide data about federation entities using the resolve endpoint.
2) Define how Intermediate entities and Trust Anchor entities in the federation provides information about federation entities to the resolver.

The goal of this specification is to support development of resolvers that can implement a defined strategy for gathering data about federation
entities and to provide a standardized API to federation entities to gather information about other entities in the federation.

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
### 1.3 Definitions

The following terms are used in this document to enhance readability:

| Term                    | Meaning                                                                                                                                                                                                                                                                                                               |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Federation service      | A defined OpenID Connect or OAuth service such as OpenID providers (OP). OpenID relying parties (RP), OAuth Authorization Services (AS), OAuth clients (Client) and Resource Servers (RS)                                                                                                                             |
| Federation node         | A Federation Entity that is not a Federation service, but serves as either Trust Anchor, Intermediate Entity, Trust Mark Issuer or Resolver                                                                                                                                                                           |
| Federation service data | The data of a federation service that includes metadata and Trust Marks, but also information such as policy. Federation service data is provided as an Entity Statement issued by a Federation Node for a subordinate entity or as Entity Configuration provided as a self signed statement by any federation entity |


<a name="federation-structure"></a>
## 2. Federation Structure

<a name="federation-entity-types"></a>
### 2.1 Federation Entity Types

The OpenID federation standard does not limit how federation roles can be mixed by a federation entity acting under a single Entity Identifier.
Mixing the role of an Intermediate Entity with a federation service role may, however, provide challenges and unnecessary complexity.

Implementers of this profile MUST NOT provide the role of an Intermediate Entity, Trust Anchor, Trust Mark Issuer or Resolver
combined with the provision of a federation service under the same EntityID.

This requirement avoids challenges such as:

- If an Intermediate Entity certifies its own Entity Configuration for its federation services.
- Conflicts between contents in the `metadata` claim and the `metadata_policy` claim in provided Entity Statements.


<a name="resolvers"></a>
### 2.2 Resolvers

Resolvers are considered essential in this profile to provide easy access to validated federation service data.
A Resolver in this profile is a Federation Entity that is providing a Resolve Entity Statement endpoint.

Each TA MUST ensure the availability of at least one Resolver that resolves federation service data to the TA federation key.

This Resolver MUST provide a discovery endpoint as defined in section 5.

<a name="metadata"></a>
## 3. Metadata

The metadata for federation services is specified in the Entity Configuration of that service under the metadata claim.
The metadata claim holds metadata per entity type.
An entity may support multiple roles by providing metadata for each supported role
(e.g. an OpenID Relying Party may also provide the role of an OAuth Client).
The OpenID federation standard allows common metadata parameters to be provided under the neutral entity type `federation_entity`.

Storing common metadata parameters for federation services under the common `federation_enttity` introduces some challenges:

- It makes it more complex to assemble relevant metadata for a federation service from its Entity Configuration
- Resolvers will not return the common `federation_enttity` metadata content if the resolve request specifies a specific entity type that is not `federation_enttity`.

Implementers of this profile MUST provide complete metadata for federation services under the entity type associated with this entity type.
Interaction with any federation service MUST NOT require obtaining the metadata specified for the `federation_enttity` entity type.

<a name="metadata-policy"></a>
## 4. Metadata Policy

**IMPORTANT NOTE: This section is based on the assumption that the current policy merge logic of the base OpenID federation standard remains
as currently specified.
It is unfortunate if it turns out to be necessary to define the no merge policy operators in this section.
It would be much preferable if the standard would allow TA control over the metadata policy in effect.**

<a name="custom-policy-operators"></a>
### 4.1 Custom policy operators

This section defines new policy operators, providing additional logic not defined in the base standard.

<a name="intersects-value-check"></a>
#### 4.1.1 Intersects value check

**Identifier**

> intersects

**Logic**

The `intersects` policy operator is a value check that holds an array of values.
The value check is successful when the metadata parameter contains at least one of the values contained in the operator.
This value check does not alter any content in the metadata parameter.
The metadata parameter MAY contain any value not contained in the policy operator as long as at least one value matches with the policy
operator values.

**Merge rules**

This policy operator must be merged in chain validation as follows:

> The merged policy operator takes the value of the most superior entity policy operator

Example: When a superior Entity Statement declares the policy operator `"intersects" : ["foo","bar"]`,
but any subordinate Entity Statements declare a different `intersects` policy operator,
the merged policy operator is `"intersects" : ["foo","bar"]` as declared by the most superior Entity Statement.

<a name="regexp-value-check"></a>
#### 4.1.2 Regexp value check

**Identifier**

> regexp

**Logic**

The `regexp` policy operator holds a regular expression.
The value check is successful if, and only if, the regular expression matches all values in the metadata parameter.

**Merge rules**

This policy operator must be merged in chain validation as follows:

> The merged policy operator takes the value of the most superior entity policy operator as described in 4.1.1.1


<a name="no-merge-policy-operators"></a>
### 4.2 No Merge Policy Operators

This section demonstrates a possible solution that would allow interconnection of federations,
while still allowing each TA to stay in control of the enforced metadata policy;

- allowing the TA to be in control over which federation services that are approved under the TA, and
- without breaking any MUST requirements of the base standard, and;
- preventing parties not conforming to this profile from processing metadata policies with a different result.

The policy operators defined in this section duplicate the logic of existing policy operators defined in the OpenID federation base standard,
but define different merge rules to allow the TA to stay in control over the enforced metadata policy.

<a name="no-merge-one-of"></a>
#### 4.2.1 No Merge one_of

**Identifier**

> nm_one_of

**Logic**

As defined by the policy operator `one_of` in OpenID federation:

>"If the metadata parameter is present, its value MUST be one of those listed in the operator value."

**Merge rules**

This policy operator must be merged in chain validation as follows:

> The merged policy operator takes the value of the most superior entity policy operator as described in 4.1.1.1

> Merge of `nm_one_of` fails if the path also contains a merged `one_of` policy operator with a different value.
> This condition MUST be treated as an error

<a name="no-merge-subset-of"></a>
#### 4.2.1 No Merge subset_of

**Identifier**

> nm_subset_of

**Logic**

As defined by the policy operator `subset_of` in OpenID federation:

>"If the metadata parameter is present,
>this operator computes the intersection between the values of the operator and the metadata parameter.
>If the intersection is non-empty, the parameter is set to the values in the intersection.
>If the intersection is empty, the result is determined by the essential operator:
>For an essential metadata parameter, the result is an error;
>for a voluntary metadata parameter, it MUST be removed from the metadata.
>Note that this behavior makes subset_of a potential value modifier in addition to it being a value check."

**Merge rules**

This policy operator must be merged in chain validation as follows:

> The merged policy operator takes the value of the most superior entity policy operator as described in 4.1.1.1

> Merge of `nm_subset_of` fails if the path also contains a merged `subset_of` policy operator with a different value.
> This condition MUST be treated as an error


<a name="no-merge-superset-of"></a>
#### 4.2.1 No Merge superset_of

**Identifier**

> nm_superset_of

**Logic**

As defined by the policy operator `superset_of` in OpenID federation:

>"If the metadata parameter is present,
> its values MUST contain those specified in the operator.
> By mathematically defining supersets, equality is included."

**Merge rules**

This policy operator must be merged in chain validation as follows:

> The merged policy operator takes the value of the most superior entity policy operator as described in 4.1.1.1

> Merge of `nm_superset_of` fails if the path also contains a merged `superset_of` policy operator with a different value.
> This condition MUST be treated as an error


<a name="policy-operator-constraints"></a>
### 4.3 Policy Operator Constraints

Implementations compliant with this profile MUST NOT use policy operators that add any value to the target entity metadata parameter
that has not been expressed by the target entity.
This requirement ensures that no metadata value is present in the processed policy that has not been intentionally declared by the
target entity.
This means that the following policy operators defined in OpenID federation MUST NOT be used:

- value
- add
- default

**NOTE:** As an alternative to using the policy operators above, an Intermediate Entity can instead add explicit values in the
metadata claim in its Entity Statement issued for the target entity.

To avoid merge conflicts,
Implementations compliant with this profile SHOULD not use policy operators in the following table,
but should instead use the listed equivalent "no merge" policy operator.

| Policy operator | Equivalent no merge policy operator |
|-----------------|-------------------------------------|
| one_of          | nm_one_of                           |
| subset_of       | nm_subset_of                        |
| superset_of     | nm_superset_of                      |


Use of any policy operators defined in this profile MUST be declared in the `metadata_policy_crit` claim of the Entity Statement.

<a name="discovery-endpoint"></a>
## 5. Discovery endpoint

The discovery endpoint is exposed by Federation Entities acting as a Resolver.
This endpoint lists all entities that can be resolved through this resolver that matches the discovery request.

The primary purpose of this endpoint is to support discovery of services such as OpenID Providers,
Authorization Servers and Resource servers, which normally makes up a fraction of all available services.
Discovery requests that include requests for client services,
such as OpenID Relying Parties and OAuth Clients, may result in a very large list.

Use of this endpoint SHOULD be used with caution when the federation includes a large population of entities.
Resolvers MAY deny or rate limit requests for client services such as OpenID Relying Parties and OAuth Clients.

<a name="federation-entity-metadata"></a>
### 5.1. Federation Entity metadata

This profile defines the `discovery_endpoint` parameter to specify the location of a Resolver's discovery endpoint.
A Resolver MUST publish its discovery endpoint location in its `federation_entity` metadata Entity Type using the `discovery_endpoint` parameter.

The discovery endpoint URL MUST use the https scheme and MAY contain port, path,
and query parameter components encoded in application/x-www-form-urlencoded format;
it MUST NOT contain a fragment component.

<a name="discovery-request"></a>
### 5.1 Discovery request

The request MUST be an HTTP request using the GET method to a list endpoint with the following query parameters,
encoded in application/x-www-form-urlencoded format.

The defined request parameters for a discovery request are:

| Parameter     | Requirement | Type               | Description                                                                                                             |
|---------------|-------------|--------------------|-------------------------------------------------------------------------------------------------------------------------|
| trust_anchor  | REQUIRED    | Single value       | The Trust Anchor the returned entities must resolve to                                                                  |
| entity_types  | OPTIONAL    | One or more values | Specifies the requested entity types. An absent parameter is interpreted as all entity types.                           |
| trust_marks   | OPTIONAL    | One or more values | Specifies the Trust Mark identifiers that must be supported by an entity for this entity to be included in the response |

The following is a non-normative example of an HTTP GET request for a list of Subordinates:

```
GET /discovery HTTP/1.1
Host: openid.example.com?trust_anchor=https%3A%2F%2Fopenid.example.com%2FTA&entity_type=openid_provider
```

<a name="discovery-response"></a>
### 5.2 Discovery response

A successful response MUST return HTTP status code 200 with the content type `application/json`,
containing a JSON array with the resolved Entity Identifiers matching the request.

If the response is negative, the response is as defined in Section 8.8 of OpenID federation.

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
## 6. Usage with OpenID Connect

<a name="oidc-request-parameters"></a>
### 6.1 OIDC Request Parameters

The OpenID federation standard (section 11) specifies the OPTIONAL inclusion of the request parameter `trust_chain` in OIDC requests.
The challenge with this request parameter is that it imposes requirements on the receiving OP to check the consistency of its content.

This profile includes requirements for Resolvers as the source of validated federation service data, making this `trust_chain` parameter
obsolete.
The OP is only expected to use this Resolver to obtain trusted federation service data, including trusted and processed metadata,
as well as trusted and validated Trust Marks.

Implementations of this profile MUST NOT include the `trust_chain` parameter in OIDC requests.
An OP receiving a request that includes `trust_chain` parameter MAY choose to either respond with an error,
or to process the request according to the processing requirements specified in OpenID federation.

<a name="security-requirements"></a>
## 7. Security Requirements

All transactions MUST be protected in transit by TLS as described in \[[NIST.800-52.Rev2](#nist800-52)\].

<a name="cryptographic-algorithms"></a>
### 5.1. Cryptographic Algorithms

The cryptographic requirements stated in [[OIDC.Sweden.profile](#oidc-profile)] applies to this profile.



<a name="normative-references"></a>
## 6. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [R. Hedberg, M.B. Jones, A.Å. Solberg, J. Bradley, G. De Marco, V. Dzhuvinov "OpenID Federation 1.0 - draft 30"](https://openid.net/specs/openid-federation-1_0.html).

<a name="nist800-52"></a>
**\[NIST.800-52.Rev2\]**
> [NIST Special Publication 800-52, Revision 2, "Guidelines for the Selection, Configuration, and Use of Transport Layer Security (TLS) Implementations"](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf).
