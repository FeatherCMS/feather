import Testing
import UserModule

import struct Foundation.Date

@testable import UserDomain

@Suite
struct RoleModelTests {

    @Test
    func createValidatesName() async throws {
        #expect(throws: Role.Model.Error.nameTooShort) {
            _ = try Role.Model.create(
                key: "role-1",
                name: "abc",
                notes: "valid"
            )
        }
    }

    @Test
    func updateValidatesNotes() async throws {
        var role = Role.Model(
            id: "r1",
            key: "role-1",
            name: "Manager",
            notes: "valid",
            createdAt: Date(),
            updatedAt: Date()
        )

        #expect(throws: Role.Model.Error.notesTooLong) {
            try role.update(notes: String(repeating: "n", count: 255))
        }
    }
}
