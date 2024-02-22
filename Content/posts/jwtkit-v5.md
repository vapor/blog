---
date: 2024-02-22 16:00
description: We've released a new version of JWTKit, and it's a big one!
tags: jwt, security, vapor
author: Paul
authorImageURL: /author-images/paul.jpg
--- 
# JWTKit is no longer Boring!

During the last few months you might have noticed an open pull request in the JWTKit repository called "V5". As you have probably already guessed, this pull request brings a new version, namely number 5, to JWTKit. Until version 4, our belowed JWT library was based mostly on a vendored copy of BoringSSL, a cryptographic library written in plain old C. While it did _work_, maintaining a wrapper around C is not modern anymore, let alone "Swifty". That's why we decided to eradicate BoringSSL from JWTKit and replace it with Swift-only internals, namely Apple's SwiftCrypto. Available as of today in a beta version is major release 5 for JWTKit.

Besides removing the C-based internals, the package got a number of upgrades. JWTKit is now fully `Sendable` and builds without warning with strict concurrency settings. 

We also added a new signing algorithm: `PSS` padded `RSA`. While `RSA` is not recommended anymore, having to use RSA with `PKCS1-v1_5` is even worse, that's why we added the (slightly) safer (but still not safe enough) version of the key. If you want to try it but can't find it, it's likely because the `RSA` key is now gated behind the `Insecure` namespace to discourage new users from using it. 

Since the internal structure has changed _quite a lot_, some changes to the API were necessary. Following is a quick tour of what's changed. To test out the new API, in your `Package.swift` file you can simply update your dependency line to:

```swift
.package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0-beta.1"),
```

Afterwards you can start upgrading your code to conform to the new APIs: the `JWTSigners` class has been upgraded to an actor called `JWTKeyCollection`:

```diff
- let signers = JWTSigners()
- signers.use(.hs256(key: "bar".bytes), kid: "foo")
+ let keyCollection = await JWTKeyCollection().addHS256("secret", kid: "foo")
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

Then, we've added some cool customisation features which weren't available before. Custom headers are now a thing, as the header is now a dictionary which you can fill however you want. To access custom fields you don't even need to use the dictionary syntax as the header is accessible using `@_dynamicMemberLookup`. For more traditional users, the usual fields are type-safely provided as extensions. A cool example of custom header use is the [Openbanking spec](// https://openbanking.atlassian.net/wiki/spaces/DZ/pages/937656404/Read+Write+Data+API+Specification+-+v3.1):

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

Parsing and serialising are now also customisable, meaning that you can define your own implementation for parsers and serialisers using the custom headers you defined, for example compressing them with `zip` or `deflate` or using a non-encoded payload by setting the `b64` header to false. Rather than implementing the whole JOSE standard, we decided to let users extend the package however they want to. In the tests there's an example which shows how to set the `b64` header to `false` (which by default is non present, meaning `true`):

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

Then, you can simply use your new parser and serialiser like this:

```swift
let keyCollection = await JWTKeyCollection()
            .addHS256(key: "secret", parser: CustomParser(), serializer: CustomSerializer())
```

and 

```swift
let token = try await keyCollection.sign(payload, header: ["b64": true])
```

Wrapping up, while the package is still in beta, we'd love your feedback! So go ahead, try it out and let us know what you love and what you hate. 
