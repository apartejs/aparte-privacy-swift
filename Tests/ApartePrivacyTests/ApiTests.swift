// API tests on the bundled model. Made-up personal data only: no real name, number or address lives in
// this repository. The text-by-text equality test against the Python reader is ParityTests.

import Foundation
import XCTest
import ApartePrivacy

final class ApiTests: XCTestCase {
    private static let privacy = try! Privacy.load()
    private var privacy: Privacy { Self.privacy }

    func testReadsTheModelHeader() {
        XCTAssertEqual(privacy.header.task, "privacy")
        XCTAssertEqual(privacy.header.version, "1.0.0")
        XCTAssertEqual(privacy.header.precision, "int8")
        XCTAssertEqual(privacy.header.subtypes, ["private_person", "private_address", "private_email", "private_phone",
                                                 "private_url", "private_date", "account_number"])
    }

    func testFindsANameWithItsKindAndRange() throws {
        let text = "Appelle Marie Lambert au 06 12 34 56 78 demain"
        let s = try XCTUnwrap(privacy.detect(text).first { $0.text.contains("Lambert") }, "\(privacy.detect(text))")
        XCTAssertEqual(s.subtype, "private_person")
        XCTAssertEqual(String(text[s.range]), s.text)
        XCTAssertGreaterThan(s.score, 0)
        XCTAssertLessThanOrEqual(s.score, 1)
    }

    func testAnEmptyOrPrivacyFreeTextGivesNothing() {
        XCTAssertEqual(privacy.detect(""), [])
        XCTAssertEqual(privacy.detect("Can you explain how photosynthesis works?"), [])
    }

    func testIgnoreAndMinScoreAreAppliedAfterTheModel() throws {
        let text = "Appelle Marie Lambert au 06 12 34 56 78 demain"
        let value = try XCTUnwrap(privacy.detect(text).first { $0.subtype == "private_person" }).text
        XCTAssertFalse(privacy.detect(text, ignore: [value]).contains { $0.text == value })
        XCTAssertEqual(privacy.detect(text, minScore: 1.01), [])
    }

    func testRejectsAFileThatIsNotAModel() {
        XCTAssertThrowsError(try Privacy(data: Data("not a model".utf8)))
    }
}
