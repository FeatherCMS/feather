import Testing
import struct Foundation.Date
@testable import UserDomain

@Suite
struct UserDomainTestSuite {

    @Test
    func accountCreateValidatesPassword() async throws {
        #expect(throws: Account.Error.passwordTooShort) {
            _ = try Account.create(
                id: "a1",
                email: "user@example.com",
                password: "short",
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func accountCreateValidatesPasswordHash() async throws {
        #expect(throws: Account.Error.passwordHashTooShort) {
            _ = try Account.create(
                id: "a1",
                email: "user@example.com",
                password: "very-secure-password",
                passwordHash: "short"
            )
        }
    }

    @Test
    func accountCreateDefaultsToActiveStatus() async throws {
        let account = try Account.create(
            id: "a1",
            email: "user@example.com",
            password: "very-secure-password",
            passwordHash: "valid-password-hash"
        )

        #expect(account.status == .active)
    }

    @Test
    func accountUpdateRequiresPasswordPairing() async throws {
        var account = makeAccount()

        #expect(throws: Account.Error.passwordHashRequired) {
            try account.update(
                password: "very-secure-password",
                passwordHash: nil
            )
        }

        #expect(throws: Account.Error.passwordRequired) {
            try account.update(
                password: nil,
                passwordHash: "valid-password-hash"
            )
        }
    }

    @Test
    func accountUpdateAcceptsPasswordAndHash() async throws {
        var account = makeAccount()

        try account.update(
            password: "very-secure-password",
            passwordHash: "new-valid-password-hash"
        )

        #expect(account.passwordHash == "new-valid-password-hash")
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

    @Test
    func invitationCreateValidatesToken() async throws {
        #expect(throws: Invitation.Error.tokenTooShort) {
            _ = try Invitation.create(
                id: "i1",
                email: "invitee@example.com",
                token: "short"
            )
        }
    }

    @Test
    func invitationConsumeThrowsWhenExpired() async throws {
        var invitation = Invitation(
            id: "i1",
            email: "invitee@example.com",
            token: "valid-token",
            expiresAt: Date().addingTimeInterval(-60),
            createdAt: Date(),
            updatedAt: Date()
        )

        #expect(throws: Invitation.Error.expired) {
            try invitation.consume()
        }
    }

    @Test
    func invitationConsumeSucceedsWhenValid() async throws {
        var invitation = Invitation(
            id: "i1",
            email: "invitee@example.com",
            token: "valid-token",
            expiresAt: Date().addingTimeInterval(60),
            createdAt: Date(),
            updatedAt: Date()
        )

        try invitation.consume()
    }
}

private func makeAccount() -> Account {
    .init(
        id: "a1",
        email: "user@example.com",
        passwordHash: "valid-password-hash",
        status: .pending,
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
