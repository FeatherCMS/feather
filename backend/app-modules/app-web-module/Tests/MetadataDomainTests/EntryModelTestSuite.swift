import Testing
import struct Foundation.Date
@testable import WebDomain

@Suite
struct EntryModelTestSuite {

    @Test
    func entryNewSucceedsWithValidInput() throws {
        let create = try Metadata.create(
            id: "entry-1",
            source: "/from",
            destination: "/to",
            statusCode: 301,
            notes: "notes"
        )

        #expect(create.id == "entry-1")
        #expect(create.source == "/from")
        #expect(create.destination == "/to")
        #expect(create.statusCode == 301)
        #expect(create.notes == "notes")
    }

    @Test
    func entryNewThrowsSourceTooShort() throws {
        #expect(throws: Metadata.Error.sourceTooShort) {
            _ = try Metadata.create(
                id: "entry-1",
                source: "",
                destination: "/to",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func entryNewThrowsSourceTooLong() throws {
        #expect(throws: Metadata.Error.sourceTooLong) {
            _ = try Metadata.create(
                id: "entry-1",
                source: String(repeating: "a", count: 255),
                destination: "/to",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func entryNewThrowsDestinationTooShort() throws {
        #expect(throws: Metadata.Error.destinationTooShort) {
            _ = try Metadata.create(
                id: "entry-1",
                source: "/from",
                destination: "",
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func entryNewThrowsDestinationTooLong() throws {
        #expect(throws: Metadata.Error.destinationTooLong) {
            _ = try Metadata.create(
                id: "entry-1",
                source: "/from",
                destination: String(repeating: "a", count: 255),
                statusCode: 301,
                notes: "notes"
            )
        }
    }

    @Test
    func entryNewThrowsInvalidStatusCode() throws {
        #expect(throws: Metadata.Error.invalidStatusCode) {
            _ = try Metadata.create(
                id: "entry-1",
                source: "/from",
                destination: "/to",
                statusCode: 200,
                notes: "notes"
            )
        }
    }

    @Test
    func entryNewThrowsNotesTooLong() throws {
        #expect(throws: Metadata.Error.notesTooLong) {
            _ = try Metadata.create(
                id: "entry-1",
                source: "/from",
                destination: "/to",
                statusCode: 301,
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func entryUpdateSucceedsWithProvidedValues() throws {
        var model = Metadata(
            id: "entry-1",
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
    func entryUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Metadata(
            id: "entry-1",
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
    func entryUpdateThrowsSourceTooShort() throws {
        var model = Metadata(
            id: "entry-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Metadata.Error.sourceTooShort) {
            try model.update(source: "")
        }
    }

    @Test
    func entryUpdateThrowsDestinationTooLong() throws {
        var model = Metadata(
            id: "entry-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Metadata.Error.destinationTooLong) {
            try model.update(destination: String(repeating: "a", count: 255))
        }
    }

    @Test
    func entryUpdateThrowsInvalidStatusCode() throws {
        var model = Metadata(
            id: "entry-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Metadata.Error.invalidStatusCode) {
            try model.update(statusCode: 201)
        }
    }

    @Test
    func entryUpdateThrowsNotesTooLong() throws {
        var model = Metadata(
            id: "entry-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: 301,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Metadata.Error.notesTooLong) {
            try model.update(notes: String(repeating: "a", count: 255))
        }
    }
}
