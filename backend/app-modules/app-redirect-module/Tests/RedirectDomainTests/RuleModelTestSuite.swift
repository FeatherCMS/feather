import Testing
import struct Foundation.Date
@testable import RedirectDomain

@Suite
struct RuleModelTestSuite {

    @Test
    func ruleNewSucceedsWithValidInput() throws {
        let create = try Rule.create(
            id: "rule-1",
            source: "/from",
            destination: "/to",
            statusCode: 301,
            notes: "notes"
        )

        #expect(create.id == "rule-1")
        #expect(create.source == "/from")
        #expect(create.destination == "/to")
        #expect(create.statusCode == 301)
        #expect(create.notes == "notes")
    }

    @Test
    func ruleNewThrowsSourceTooShort() throws {
        #expect(throws: Rule.Error.sourceTooShort) {
            _ = try Rule.create(
                id: "rule-1",
                source: "",
                destination: "/to",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsSourceTooLong() throws {
        #expect(throws: Rule.Error.sourceTooLong) {
            _ = try Rule.create(
                id: "rule-1",
                source: String(repeating: "a", count: 255),
                destination: "/to",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsDestinationTooShort() throws {
        #expect(throws: Rule.Error.destinationTooShort) {
            _ = try Rule.create(
                id: "rule-1",
                source: "/from",
                destination: "",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsDestinationTooLong() throws {
        #expect(throws: Rule.Error.destinationTooLong) {
            _ = try Rule.create(
                id: "rule-1",
                source: "/from",
                destination: String(repeating: "a", count: 255),
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsInvalidStatusCode() throws {
        #expect(throws: Rule.Error.invalidStatusCode) {
            _ = try Rule.create(
                id: "rule-1",
                source: "/from",
                destination: "/to",
                statusCode: 200,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsNotesTooLong() throws {
        #expect(throws: Rule.Error.notesTooLong) {
            _ = try Rule.create(
                id: "rule-1",
                source: "/from",
                destination: "/to",
                statusCode: 301,
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func ruleUpdateSucceedsWithProvidedValues() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update(
            source: "/from-b",
            destination: "/to-b",
            statusCode: 308,
            notes: "notes-b"
        )

        #expect(model.source == "/from-b")
        #expect(model.destination == "/to-b")
        #expect(model.statusCode == 308)
        #expect(model.notes == "notes-b")
    }

    @Test
    func ruleUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 302,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update()

        #expect(model.source == "/from-a")
        #expect(model.destination == "/to-a")
        #expect(model.statusCode == 302)
        #expect(model.notes == "notes-a")
    }

    @Test
    func ruleUpdateThrowsSourceTooShort() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Rule.Error.sourceTooShort) {
            try model.update(source: "")
        }
    }

    @Test
    func ruleUpdateThrowsDestinationTooLong() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Rule.Error.destinationTooLong) {
            try model.update(destination: String(repeating: "a", count: 255))
        }
    }

    @Test
    func ruleUpdateThrowsInvalidStatusCode() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Rule.Error.invalidStatusCode) {
            try model.update(statusCode: 201)
        }
    }

    @Test
    func ruleUpdateThrowsNotesTooLong() throws {
        var model = Rule(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Rule.Error.notesTooLong) {
            try model.update(notes: String(repeating: "a", count: 255))
        }
    }
}
