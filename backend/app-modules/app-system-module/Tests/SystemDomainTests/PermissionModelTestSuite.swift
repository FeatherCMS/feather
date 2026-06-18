import Testing
import struct Foundation.Date
@testable import SystemDomain

@Suite
struct PermissionModelTestSuite {

    @Test
    func permissionNewSucceedsWithValidInput() throws {
        let create = try Permission.create(
            id: "perm-1",
            name: "abcd",
            notes: "notes"
        )

        #expect(create.id == "perm-1")
        #expect(create.name == "abcd")
        #expect(create.notes == "notes")
    }

    @Test
    func permissionNewThrowsNameTooShort() throws {
        #expect(throws: Permission.Error.nameTooShort) {
            _ = try Permission.create(
                id: "perm-1",
                name: "abc",
                notes: "notes"
            )
        }
    }

    @Test
    func permissionNewThrowsNameTooLong() throws {
        #expect(throws: Permission.Error.nameTooLong) {
            _ = try Permission.create(
                id: "perm-1",
                name: String(repeating: "a", count: 255),
                notes: "notes"
            )
        }
    }

    @Test
    func permissionNewThrowsNotesTooLong() throws {
        #expect(throws: Permission.Error.notesTooLong) {
            _ = try Permission.create(
                id: "perm-1",
                name: "abcd",
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func permissionUpdateSucceedsWithProvidedValues() throws {
        var model = Permission(
            id: "perm-1",
            name: "name-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update(name: "name-b", notes: "notes-b")

        #expect(model.name == "name-b")
        #expect(model.notes == "notes-b")
    }

    @Test
    func permissionUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Permission(
            id: "perm-1",
            name: "name-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update()

        #expect(model.name == "name-a")
        #expect(model.notes == "notes-a")
    }

    @Test
    func permissionUpdateThrowsNameTooShort() throws {
        var model = Permission(
            id: "perm-1",
            name: "name-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Permission.Error.nameTooShort) {
            try model.update(name: "abc")
        }
    }

    @Test
    func permissionUpdateThrowsNameTooLong() throws {
        var model = Permission(
            id: "perm-1",
            name: "name-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Permission.Error.nameTooLong) {
            try model.update(name: String(repeating: "a", count: 255))
        }
    }

    @Test
    func permissionUpdateThrowsNotesTooLong() throws {
        var model = Permission(
            id: "perm-1",
            name: "name-a",
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: Permission.Error.notesTooLong) {
            try model.update(notes: String(repeating: "a", count: 255))
        }
    }
}
