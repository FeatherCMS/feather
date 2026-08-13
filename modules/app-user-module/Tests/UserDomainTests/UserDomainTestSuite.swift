//
//  UserDomainTestSuite.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Testing

import struct Foundation.Date

@testable import UserDomain

@Suite
struct UserDomainTestSuite {

    @Test
    func identityCreateDefaultsToActiveStatus() async throws {
        let identity = Identity.create()

        #expect(identity.status == .active)
    }

    @Test
    func identityUpdateChangesStatus() async throws {
        var identity = makeIdentity()
        identity.update(status: .active)
        #expect(identity.status == .active)
    }

    @Test
    func roleCreateValidatesName() async throws {
        #expect(throws: Role.Error.nameTooShort) {
            _ = try Role.create(
                id: "r1",
                name: "abc",
                notes: "valid"
            )
        }
    }

    @Test
    func roleUpdateValidatesNotes() async throws {
        var role = makeRole()

        #expect(throws: Role.Error.notesTooLong) {
            try role.update(notes: String(repeating: "n", count: 255))
        }
    }

}

private func makeIdentity() -> Identity {
    .init(
        id: "a1",
        status: .invited,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRole() -> Role {
    .init(
        id: "r1",
        name: "Manager",
        notes: "valid",
        createdAt: Date(),
        updatedAt: Date()
    )
}
