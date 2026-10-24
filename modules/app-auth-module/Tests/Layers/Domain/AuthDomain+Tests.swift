import AuthModule
import Testing

import struct Foundation.Date

@testable import AuthDomain

//
//  AuthDomain+Tests.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

@Suite
struct AuthDomainTests {

    @Test
    func emailUpdateAppliesFieldChanges() {
        var email = Email.Model(
            id: "email-1",
            identityId: "identity-1",
            email: "old@example.com",
            createdAt: Date(),
            updatedAt: Date()
        )

        email.update(
            identityId: .set("identity-2"),
            email: .set("new@example.com")
        )

        #expect(email.identityId == "identity-2")
        #expect(email.email == "new@example.com")
    }

    @Test
    func credentialCreateSucceedsWithValidValues() throws {
        let credentials = try Credential.Model.create(
            authEmailId: "auth-email-1",
            passwordHash: "valid-password-hash"
        )

        #expect(credentials.authEmailId == "auth-email-1")
        #expect(credentials.passwordHash == "valid-password-hash")
    }

    @Test
    func credentialCreateValidatesAuthEmailID() {
        #expect(throws: Credential.Model.Error.authEmailIdTooShort) {
            _ = try Credential.Model.create(
                authEmailId: "a1",
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func credentialCreateValidatesAuthEmailIDLength() {
        #expect(throws: Credential.Model.Error.authEmailIdTooLong) {
            _ = try Credential.Model.create(
                authEmailId: String(repeating: "a", count: 255),
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func credentialCreateValidatesPasswordHashBoundaries() {
        #expect(throws: Credential.Model.Error.passwordHashTooShort) {
            _ = try Credential.Model.create(
                authEmailId: "auth-email-1",
                passwordHash: "12345678"
            )
        }

        #expect(throws: Credential.Model.Error.passwordHashTooLong) {
            _ = try Credential.Model.create(
                authEmailId: "auth-email-1",
                passwordHash: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func credentialUpdateValidatesAndChangesValues() throws {
        var credentials = makeCredential()

        try credentials.update(passwordHash: .set("updated-password-hash"))

        #expect(credentials.passwordHash == "updated-password-hash")
    }

    @Test
    func credentialUpdateValidatesNewValues() throws {
        var credentials = makeCredential()

        #expect(throws: Credential.Model.Error.authEmailIdTooShort) {
            try credentials.update(authEmailId: .set("a1"))
        }
        #expect(throws: Credential.Model.Error.passwordHashTooShort) {
            try credentials.update(passwordHash: .set("12345678"))
        }
    }

    @Test
    func magicLinkCreateValidatesToken() async throws {
        #expect(throws: MagicLink.Model.Error.tokenTooShort) {
            _ = try MagicLink.Model.create(
                authEmailId: "auth-email-1",
                token: "short",
                isPersistent: true
            )
        }
    }

    @Test
    func magicLinkConsumeThrowsWhenAlreadyUsed() async throws {
        var magicLink = makeMagicLink(isUsed: true, expiresAfter: 60)

        #expect(throws: MagicLink.Model.Error.alreadyUsed) {
            try magicLink.consume()
        }
    }

    @Test
    func magicLinkConsumeThrowsWhenExpired() async throws {
        var magicLink = makeMagicLink(isUsed: false, expiresAfter: -60)

        #expect(throws: MagicLink.Model.Error.expired) {
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
        #expect(throws: Session.Model.Error.tokenTooShort) {
            _ = try Session.Model.create(
                token: "short",
                identityId: "identity-1",
                authenticationType: Session.Model.AuthenticationTypes
                    .credential,
                authenticationReference: "credential-1",
                expiresAtInterval: Session.Model.Lifetimes.regular,
                isPersistent: false
            )
        }
    }

    @Test
    func sessionCreateValidatesIdentityId() async throws {
        #expect(throws: Session.Model.Error.identityIdTooShort) {
            _ = try Session.Model.create(
                token: "valid-session-token",
                identityId: "a1",
                authenticationType: Session.Model.AuthenticationTypes
                    .credential,
                authenticationReference: "credential-1",
                expiresAtInterval: Session.Model.Lifetimes.regular,
                isPersistent: false
            )
        }
    }

    @Test
    func rolePermissionCreateValidatesRoleId() async throws {
        #expect(throws: RolePermission.Model.Error.roleIdTooShort) {
            _ = try RolePermission.Model.create(
                roleId: "r1",
                permissionId: "perm-1"
            )
        }
    }

    @Test
    func rolePermissionCreateValidatesPermissionId() async throws {
        #expect(
            throws: RolePermission.Model.Error.permissionIdTooShort
        ) {
            _ = try RolePermission.Model.create(
                roleId: "role-1",
                permissionId: "p1"
            )
        }
    }
}

private func makeMagicLink(
    isUsed: Bool,
    expiresAfter: Double
) -> MagicLink.Model {
    .init(
        id: "m1",
        authEmailId: "auth-email-1",
        token: "valid-token-value",
        expiresAt: Date().addingTimeInterval(expiresAfter),
        isPersistent: true,
        isUsed: isUsed,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeCredential() -> Credential.Model {
    .init(
        id: "credential-1",
        authEmailId: "auth-email-1",
        passwordHash: "valid-password-hash",
        createdAt: Date(),
        updatedAt: Date()
    )
}
