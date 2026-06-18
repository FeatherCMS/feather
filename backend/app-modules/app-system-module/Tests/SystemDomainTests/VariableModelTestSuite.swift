import Testing
import struct Foundation.Date
@testable import SystemDomain

@Suite
struct VariableModelTestSuite {

    @Test
    func variableNewSucceedsWithValidInput() throws {
        let create = try Variable.create(
            id: "var-1",
            name: "abcd",
            value: "value",
            notes: "notes"
        )

        #expect(create.id == "var-1")
        #expect(create.name == "abcd")
        #expect(create.value == "value")
        #expect(create.notes == "notes")
    }

    @Test
    func variableNewThrowsNameTooShort() throws {
        #expect(throws: Variable.Error.nameTooShort) {
            _ = try Variable.create(
                id: "var-1",
                name: "abc",
                value: "value",
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsNameTooLong() throws {
        #expect(throws: Variable.Error.nameTooLong) {
            _ = try Variable.create(
                id: "var-1",
                name: String(repeating: "a", count: 255),
                value: "value",
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsValueTooLong() throws {
        #expect(throws: Variable.Error.valueTooLong) {
            _ = try Variable.create(
                id: "var-1",
                name: "abcd",
                value: String(repeating: "a", count: 255),
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsNotesTooLong() throws {
        #expect(throws: Variable.Error.notesTooLong) {
            _ = try Variable.create(
                id: "var-1",
                name: "abcd",
                value: "value",
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func variableUpdateSucceedsWithProvidedValues() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update(
            name: "name-b",
            value: "value-b",
            notes: "notes-b"
        )

        #expect(model.name == "name-b")
        #expect(model.value == "value-b")
        #expect(model.notes == "notes-b")
    }

    @Test
    func variableUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update()

        #expect(model.name == "name-a")
        #expect(model.value == "value-a")
        #expect(model.notes == "notes-a")
    }

    @Test
    func variableUpdateThrowsNameTooShort() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Variable.Error.nameTooShort) {
            try model.update(name: "abc")
        }
    }

    @Test
    func variableUpdateThrowsNameTooLong() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Variable.Error.nameTooLong) {
            try model.update(name: String(repeating: "a", count: 255))
        }
    }

    @Test
    func variableUpdateThrowsValueTooLong() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Variable.Error.valueTooLong) {
            try model.update(value: String(repeating: "a", count: 255))
        }
    }

    @Test
    func variableUpdateThrowsNotesTooLong() throws {
        var model = Variable(
            id: "var-1",
            name: "name-a",
            value: "value-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Variable.Error.notesTooLong) {
            try model.update(notes: String(repeating: "a", count: 255))
        }
    }
}
