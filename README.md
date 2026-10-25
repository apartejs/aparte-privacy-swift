# ApartePrivacy for Swift

Finds personal data in text on the device: names, addresses, emails, phone numbers, URLs, dates and account numbers. The [aparte-privacy](https://huggingface.co/apartejs/aparte-privacy) model (196 KB, int8) is bundled. Offline, no dependency but Foundation.

```swift
import ApartePrivacy

let privacy = try Privacy.load()   // load once, share across threads
privacy.detect("My name is John Smith and my email is john.smith@gmail.com")
// [Span(11..<21, text: "John Smith", subtype: private_person, score: 1.0),
//  Span(38..<58, text: "john.smith@gmail.com", subtype: private_email, score: 1.0)]
```

Each `Span` has its `text`, its `subtype` (one of the seven categories), a `score` from 0 to 1, its `range` in the string and its `utf16Range`, the offsets the JavaScript and Kotlin runtimes report.

The model reports raw spans; `minScore`, `ignore` (exact values) and `ignorePatterns` (regular expressions) are your policy, applied after it.

## Limits

- Names are the weakest category: 0.77 F1 on our test set and 0.85 on short messages, against 0.9 and more for the others.
- A product or service name can be taken for a name, above all next to a key (« ma clé Slack : … ») or at the start of a message. Use `ignore` for the ones you know.
- Public figures and fictional characters are masked too. Use `ignore` for the names you want to keep.
- Short messages were the weak spot of model v1 (names F1 0.35 on 1,067 short chat messages); v1.1 reaches 0.85 there.
- English and French only, as tested.

## Install

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/apartejs/aparte-privacy-swift.git", from: "1.1.0"),
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
