# ApartePrivacy for Swift

Finds personal data in text on the device: names, addresses, emails, phone numbers, URLs, dates and account numbers. The [aparte-privacy](https://huggingface.co/apartejs/aparte-privacy) model (196 KB, int8) is bundled. Offline, no dependency but Foundation.

```swift
import ApartePrivacy

let privacy = try Privacy.load()   // load once, share across threads
privacy.detect("My name is John Smith and my email is john.smith@gmail.com")
// [Span(11..<21, text: "John Smith", subtype: private_person, score: 0.9999),
//  Span(38..<58, text: "john.smith@gmail.com", subtype: private_email, score: 0.9956)]
```

Each `Span` has its `text`, its `subtype` (one of the seven categories), a `score` from 0 to 1, its `range` in the string and its `utf16Range`, the offsets the JavaScript and Kotlin runtimes report.

The model reports raw spans; `minScore`, `ignore` (exact values) and `ignorePatterns` (regular expressions) are your policy, applied after it.

## Limits

- **Short messages are its weak spot.** On a message of a few words, it misses most names and some phone numbers (on 100 short synthetic messages: names found 9 times out of 100, phone numbers 59 out of 100, at score 0.5). Inside a longer request it finds them far more often. Do not rely on it alone for short messages.
- Names are the weakest category: about 0.66 F1 on our test set, against 0.9 and more for the others.
- Public figures and fictional characters are masked too. Use `ignore` for the names you want to keep.
- English and French only, as tested.

## Install

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/apartejs/aparte-privacy-swift.git", from: "1.0.0"),
],
```

iOS 13, macOS 10.15, tvOS 13, watchOS 6, visionOS 1, and Linux and Windows.

## Tests

```bash
swift test -c release                                              # API tests
APARTE_PRIVACY_REFS=references_int8.jsonl swift test -c release    # + equality with the reference spans
```

The reference file is on [Hugging Face](https://huggingface.co/apartejs/aparte-privacy/tree/main).

## License

MIT, Copyright (c) 2026 Paul Richez.
