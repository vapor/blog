---
date: 2026-04-10 12:00
description: Post quantum JWTs are here!
tags: jwt, security, vapor
authors: Francesco; Paul
authorImageURLs: /author-images/francesco.jpg; /author-images/paul.jpg
--- 

# Post Quantum JWTs

At WWDC25, [post-quantum cryptography](https://developer.apple.com/videos/play/wwdc2025/314/) for the Apple ecosystem was announced.
This means that with the new version 26 lineup of Apple's operating systems, CryptoKit bundles APIs for using quantum-secure signatures and encryption.

Along with CryptoKit, the server world also obtains access to those APIs via Swift Crypto, and JWTKit seized the opportunity to implement post-quantum flavoured JWTs.

## Post Quantum Cryptography

Post quantum cryptography is currently a very hot topic, and there are lots of resources available for diving more into it, but the gist of it is that we need to get ahead and prepare ourselves for the time when quantum computers will be widely accessible.
Some time in the near future, quantum computing will not be limited to universities and certain very specific fields anymore; it will become more and more accessible to the public. The theory behind quantum computing is very different from the machines we are used to today, making them far more powerful in certain respects, with the result that many of the security measures we use today will be obsolete.

> Check out [Google's announcement](https://research.google/blog/safeguarding-cryptocurrency-by-disclosing-quantum-vulnerabilities-responsibly/) about EC keys being broken much sooner than expected.

This is why we have to be ready to implement and utilise stronger safety mechanisms around our data.
Not just because we'll be vulnerable _someday_, but also because even today data our current computers can’t crack gets [harvested and stored until it can be decrypted](https://en.wikipedia.org/wiki/Harvest_now,_decrypt_later) using quantum computers.

## Quantum-Secure Digital Signatures

The newest versions of CryptoKit and Swift Crypto include APIs for quantum-secure digital signatures using the ML-DSA algorithm (previously known as Dilithium) in two parameter sets: `ML-DSA-65` and `ML-DSA-87`.

ML-DSA is a module lattice-based signature scheme, meaning that its security relies on the hardness of a problem for which no efficient solution is known, even for quantum computers.
This is not the case, for example, for RSA or Elliptic-curve cryptography (ECC), which are based on problems that can be easily solved by quantum computers that work at full capacity (which are still a few years away).

ML-DSA was standardized by NIST in [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final), along with the `ML-DSA-44` parameter set, which is not currently supported by CryptoKit and Swift Crypto.
Other post-quantum signature schemes include SLH-DSA ([FIPS 205](https://csrc.nist.gov/pubs/fips/205/final)), which is based on the hardness of cryptographic hash functions, and FN-DSA, which is still in the process of being standardized as FIPS 206.

## ML-DSA JWTs

Thanks to Swift Crypto, ML-DSA is now easily accessible in Swift; we therefore seized the moment and implemented ML-DSA based JWT signing. With version 5.3.0, JWTKit can be imported via
```swift
@_spi(PostQuantum) import JWTKit
```
> **Note:** For the time being, we had to gate the new algorithm behind an `@_spi` flag, because while the signing algorithm is formalised, its use in JWTs is still in [draft state](https://datatracker.ietf.org/doc/draft-ietf-cose-dilithium/).

This import unlocks two new signing keys: `MLDSA65PrivateKey` and `MLDSA87PrivateKey`, along with their public counterparts. These can be created via `seedRepresentation`s and added to the usual key collection via
```swift
let seedRepresentation = Data(fromHexEncodedString: mldsa87PrivateKeySeedRepresentation)
let key = try MLDSA87PrivateKey(seedRepresentation: seedRepresentation)
await keyCollection.add(mldsa: key)
```
Signing a token using this key will produce a _huge_ string: an ML-DSA 87 signature is 4.6 KB, compared to the ~0.1 KB of ES512. 
Decoding it on jwt.io will yield a header similar to this:
```json
{
  "alg": "ML-DSA-65",
  "typ": "JWT"
}
```
And there you go, a shiny, post-quantum safe JWT.

Check out the [5.3.0 release](https://github.com/vapor/jwt-kit/releases/tag/5.3.0) for full details, and let’s start protecting our data for the future!
