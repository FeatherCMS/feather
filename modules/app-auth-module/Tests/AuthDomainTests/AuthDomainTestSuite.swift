//
//  AuthDomainTestSuite.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Testing

import struct Foundation.Date
import typealias Foundation.TimeInterval

@testable import AuthDomain

@Suite
struct AuthDomainTestSuite {

    @Test
    func credentialCreateSucceedsWithValidValues() throws {
        let credentials = try Credential.create(
            userId: "user-1",
            email: "user@example.com",
            passwordHash: "valid-password-hash"
        )

        #expect(credentials.userId == "user-1")
        #expect(credentials.email == "user@example.com")
        #expect(credentials.passwordHash == "valid-password-hash")
    }

    @Test
    func credentialCreateValidatesIdentityID() {
        #expect(throws: Credential.Error.invalidUserId) {
            _ = try Credential.create(
                userId: "",
                email: "user@example.com",
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func credentialCreateValidatesEmailBoundaries() {
        #expect(throws: Credential.Error.emailTooShort) {
            _ = try Credential.create(
                userId: "user-1",
                email: "abc",
                passwordHash: "valid-password-hash"
            )
        }

        #expect(throws: Credential.Error.emailTooLong) {
            _ = try Credential.create(
                userId: "user-1",
                email: String(repeating: "a", count: 255),
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func credentialCreateValidatesPasswordHashBoundaries() {
        #expect(throws: Credential.Error.passwordHashTooShort) {
            _ = try Credential.create(
                userId: "user-1",
                email: "user@example.com",
                passwordHash: "12345678"
            )
        }

        #expect(throws: Credential.Error.passwordHashTooLong) {
            _ = try Credential.create(
                userId: "user-1",
                email: "user@example.com",
                passwordHash: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func credentialUpdateValidatesAndChangesValues() throws {
        var credentials = makeCredential()

        try credentials.update(
            email: "updated@example.com",
            passwordHash: "updated-password-hash"
        )

        #expect(credentials.email == "updated@example.com")
        #expect(credentials.passwordHash == "updated-password-hash")
    }

    @Test
    func credentialUpdateValidatesNewValues() throws {
        var credentials = makeCredential()

        #expect(throws: Credential.Error.emailTooShort) {
            try credentials.update(email: "abc")
        }
        #expect(throws: Credential.Error.passwordHashTooShort) {
            try credentials.update(passwordHash: "12345678")
        }
    }

    @Test
    func magicLinkCreateValidatesToken() async throws {
        #expect(throws: MagicLink.Error.tokenTooShort) {
            _ = try MagicLink.create(
                credentialId: "credential-1",
                token: "short",
                isPersistent: true
            )
        }
    }

    @Test
    func magicLinkConsumeThrowsWhenAlreadyUsed() async throws {
        var magicLink = makeMagicLink(isUsed: true, expiresAfter: 60)

        #expect(throws: MagicLink.Error.alreadyUsed) {
            try magicLink.consume()
        }
    }

    @Test
    func magicLinkConsumeThrowsWhenExpired() async throws {
        var magicLink = makeMagicLink(isUsed: false, expiresAfter: -60)

        #expect(throws: MagicLink.Error.expired) {
            try magicLink.consume()
        }
    }

    @Test
    func magicLinkConsumeMarksAsUsed() async throws {
        var magicLink = makeMagicLink(isUsed: false, expiresAfter: 60)

        try magicLink.consume()

        #expect(magicLink.isUsed)
    }

    @Test
    func sessionCreateValidatesToken() async throws {
        #expect(throws: Session.Error.tokenTooShort) {
            _ = try Session.create(
                token: "short",
                identityId: "identity-1",
                authenticationType: Session.AuthenticationTypes.credential,
                authenticationReference: "credential-1",
                expiresAtInterval: Session.Lifetimes.regular,
                isPersistent: false
            )
        }
    }

    @Test
    func sessionCreateValidatesIdentityId() async throws {
        #expect(throws: Session.Error.identityIdTooShort) {
            _ = try Session.create(
                token: "valid-session-token",
                identityId: "a1",
                authenticationType: Session.AuthenticationTypes.credential,
                authenticationReference: "credential-1",
                expiresAtInterval: Session.Lifetimes.regular,
                isPersistent: false
            )
        }
    }

    @Test
    func rolePermissionCreateValidatesRoleId() async throws {
        #expect(throws: RolePermission.Error.roleIdTooShort) {
            _ = try RolePermission.create(
                roleId: "r1",
                permissionId: "perm-1"
            )
        }
    }

    @Test
    func rolePermissionCreateValidatesPermissionId() async throws {
        #expect(throws: RolePermission.Error.permissionIdTooShort) {
            _ = try RolePermission.create(
                roleId: "role-1",
                permissionId: "p1"
            )
        }
    }
}

private func makeMagicLink(
    isUsed: Bool,
    expiresAfter: TimeInterval
) -> MagicLink {
    .init(
        id: "m1",
        credentialId: "credential-1",
        token: "valid-token-value",
        expiresAt: Date().addingTimeInterval(expiresAfter),
        isPersistent: true,
        isUsed: isUsed,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeCredential() -> Credential {
    .init(
        id: "credential-1",
        userId: "user-1",
        email: "user@example.com",
        passwordHash: "valid-password-hash",
        createdAt: Date(),
        updatedAt: Date()
    )
}
