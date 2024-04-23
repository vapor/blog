---
date: 2024-02-28 16:00
description: We've released a new version of JWTKit, and it's a big one!
tags: jwt, security, vapor
authors: Paul; Tim
authorImageURLs: /author-images/paul.jpg; /author-images/tim.jpg
--- 
# JWTKit is no longer Boring!

> Updated for JWTKit Beta 3.

## Swift 6 is on the Horizon

If you follow the Swift forums carefully you might have noticed [the announcement](https://forums.swift.org/t/progress-toward-the-swift-6-language-mode/68315/33) that Swift 5.10 will be the last release before Swift 6. This provides Vapor a timeline for a future Vapor 5 release and we can start planning as to what that will look like.

A large part of that will be updating and migrating all of our packages to take advantage of modern Swift language features and design patterns, foremost among which is structured concurrency. The first package to be updated is JWTKit, which has been in the works for a while now.

Future posts will discuss Vapor 5, Fluent 5, and other future directions, so let's have a look at what's new in JWTKit.

## JWTKit V5

Over the last few months, you may have noticed an open pull request in the JWTKit repository entitled "V5". As you have probably already guessed, this pull request brings a new major version, namely number 5, to JWTKit. In the past, including in version 4, our beloved JWT library was based mostly on a vendored copy of [BoringSSL](https://boringssl.googlesource.com/boringssl/), a cryptographic library written in plain old C, one of the several spinoffs of the [OpenSSL](https://openssl.org) project. While it did _work_, maintaining a wrapper around C is not modern anymore, let alone "Swifty". It introduced potential safety issues calling through to C code and added a significant amount to your app's compile time - [SwiftCrypto](https://github.com/apple/swift-crypto) includes another entire copy that gets separately compiled, even though it's the same code! That's why we decided to eradicate BoringSSL from JWTKit and replace it with Swift-only internals, namely SwiftCrypto itself. Available as of today in a beta version is major release 5 for JWTKit.

Besides removing the C-based internals, the package got a number of upgrades. JWTKit is now fully `Sendable`-correct and builds with zero warnings in strict concurrency mode. 

We also added a new signing algorithm: `PSS`-padded `RSA` (aka `RSA-PSS`). Although `RSA` is no longer considered future-proof and should be avoided whenever possible, using RSA with the much older PKCS#1 v1.5 padding is _known_ to be unsafe today - so we added support for the safer (though still not recommended) padding mode. If you want to try it but can't find it, it's likely because `RSA` key types are now nested within the `Insecure` namespace, to discourage new users from using it. 

## Upgrading

### JWTKit

> **Note:** Most people using JWT support with Vapor will need to update the [vapor/jwt](https://github.com/vapor/jwt) integration package, as discussed below.

Since the internal structure of the package has changed _considerably_, some changes to the API were necessary (along with a few changes that have been waiting their turn for far too long). Following is a quick tour of what's changed. To test out the new API, simply update the dependency in your package manifest (`Package.swift`):

```swift
.package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0-beta.3"),
```

Afterwards you can start upgrading your code to conform to the new APIs. Firstly, the `JWTSigners` class has been redesigned as an `actor`, and is now named `JWTKeyCollection`:

```diff
- let signers = JWTSigners()
- signers.use(.hs256(key: "bar".bytes), kid: "foo")
+ let keyCollection = await JWTKeyCollection().addHMAC("secret", digestAlgorithm: .sha256, kid: "foo")
```

Signing now works like this:

```diff
let payload = YourPayload(...)
- let token = signers.sign(payload, kid: "foo")
+ let token = try await keyCollection.sign(payload, header: ["kid": "foo"])
```

All of the parameters you used to pass into the `sign` method such as `kid`, `cty` etc. are now to be submitted into the header directly. Verifying looks like this:

```diff
- let payload = signers.verify(token, as: YourPayload.self)
+ let payload = try await keyCollection.verify(token, as: YourPayload.self)
```

### JWT

If you want to try out version 5 using the Vapor integration, you need to update your dependency to:

```swift
.package(url: "https://github.com/vapor/jwt", from: "5.0.0-beta.2"),
```

and then migrate to the new API:

```diff
- app.jwt.signers.use(.hs256(key: "secret"), kid: "foo")
+ await app.jwt.keys.addHMAC(key: "secret", digestAlgorithm: .sha256, kid: "foo")
```

After adding a key, you can create your payload like:

```diff
struct SomePayload: JWTPayload {
    var exampleName: String
    
    // the claims did not change

-   func verify(using signer: JWTSigner) throws {
+   func verify(using signer: some JWTAlgorithm) async throws {
        // ... 
    }
}
```

Adn then you can sign and verify your tokens like this:

```diff
- let token = try signers.sign(SomePayload(exampleName: "bob"), kid: "foo")
+ let token = try await app.jwt.keys.sign(SomePayload(exampleName: "bob"), header: ["kid": "foo"])

- let payload = try signers.verify(token, as: SomePayload.self)
+ let payload = try await app.jwt.keys.verify(token, as: SomePayload.self)
```

The rest of the methods are basically the same, but asynchronous.

## Customization

As if that wasn't enough, we've also added some cool new customization features. Custom headers are now supported; the token header is now a dictionary which you can fill however you want. Accessing custom fields doesn't even require dictionary subscript syntax - the header provides direct property access via `@_dynamicMemberLookup`. For more traditional users, the usual fields are provided as type-safe extensions. A cool example of custom header use is the [Open Banking spec](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/937656404/Read+Write+Data+API+Specification+-+v3.1):

```swift
let customFields: JWTHeader = [
    "kid": "90210ABAD",
    "http://openbanking.org.uk/iat": 1_501_497_671,
    "http://openbanking.org.uk/iss": "C=UK, ST=England, L=London, O=Acme Ltd.",
    "http://openbanking.org.uk/tan": "openbanking.org.uk",
    "crit": [
        "b64",
        "http://openbanking.org.uk/iat",
        "http://openbanking.org.uk/iss",
        "http://openbanking.org.uk/tan"
    ],
]
let token = try await keyCollection.sign(payload, header: customFields)
```

Parsing and serializing are now also customizable, meaning that you can define your own implementation for parsers and serializers using the custom headers you defined, for example compressing them with `zip` or `deflate`, or using an unencoded payload by setting the `b64` header to `false`. Rather than implementing the entire JOSE standard, we decided to let users extend the package as desired. The tests include an example which shows how to set the `b64` header (which by default is not present and thus assumed to have the value `true`):

```swift
struct CustomSerializer: JWTSerializer {
    // Here you can set a custom encoder or just leave this as default
    var jsonEncoder: JWTJSONEncoder = .defaultForJWT

    // This method should return the payload in the way you want/need it
    func serialize(_ payload: some JWTPayload, header: JWTHeader) throws -> Data {
        // Check if the b64 header is set. If it is, base64URL encode the payload, don't otherwise
        if header.b64?.asBool == true {
            try Data(jsonEncoder.encode(payload).base64URLEncodedBytes())
        } else {
            try jsonEncoder.encode(payload)
        }
    }
}

struct CustomParser: JWTParser {
    // Here you can set a custom decoder or just leave this as default
    var jsonDecoder: JWTJSONDecoder = .defaultForJWT

    // This method parses the token into a tuple containing the various token's elements
    func parse<Payload>(_ token: some DataProtocol, as: Payload.Type) throws -> (header: JWTHeader, payload: Payload, signature: Data) where Payload: JWTPayload {
        // A helper method is provided to split the token correctly
        let (encodedHeader, encodedPayload, encodedSignature) = try getTokenParts(token)

        // The header is usually always encoded the same way
        let header = try jsonDecoder.decode(JWTHeader.self, from: .init(encodedHeader.base64URLDecodedBytes()))

        // If the b64 header field is non present or true, base64URL decode the payload, don't otherwise
        let payload = if header.b64?.asBool ?? true {
            try jsonDecoder.decode(Payload.self, from: .init(encodedPayload.base64URLDecodedBytes()))
        } else {
            try jsonDecoder.decode(Payload.self, from: .init(encodedPayload))
        }

        // The signature is usually also always encoded the same way
        let signature = Data(encodedSignature.base64URLDecodedBytes())

        return (header: header, payload: payload, signature: signature)
    }
}
```

Then, you can simply use your new parser and serializer like this:

```swift
let keyCollection = await JWTKeyCollection().addHMAC(
    key: "secret", 
    digestAlgorithm: .sha256, 
    parser: CustomParser(), 
    serializer: CustomSerializer()
)
```

and 

```swift
let token = try await keyCollection.sign(payload, header: ["b64": true])
```

Wrapping up, while the package is still in beta, we'd love your feedback! So go ahead, try it out and let us know what you love and what you hate. 

