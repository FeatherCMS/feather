import Foundation
import Testing

@testable import AccountDomain

@Suite
struct InvitationTests {

    @Test
    func storesAssignedRoleIDs() throws {
        let invitation = try Invitation.create(
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor", "role-author"]
        )

        #expect(invitation.roleIDs == ["role-editor", "role-author"])
    }

    @Test
    func renewsInvitationWithNewTokenAndExpiry() throws {
        let created = try Invitation.create(
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor"]
        )
        var invitation = Invitation(
            id: "invitation-1",
            userId: created.userId,
            email: created.email,
            token: created.token,
            roleIDs: created.roleIDs,
            expiresAt: Date().addingTimeInterval(-1),
            createdAt: Date(),
            updatedAt: Date()
        )

        try invitation.renew(
            token: "token-renewed",
            expiresAt: Date().addingTimeInterval(3600)
        )

        #expect(invitation.token == "token-renewed")
        #expect(invitation.roleIDs == ["role-editor"])
    }

    @Test
    func updatesRoleIDsWithoutChangingEmail() throws {
        let created = try Invitation.create(
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456"
        )
        var invitation = Invitation(
            id: "invitation-1",
            userId: created.userId,
            email: created.email,
            token: created.token,
            roleIDs: [],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )

        try invitation.update(email: nil, roleIDs: ["role-editor"])

        #expect(invitation.email == "user@example.com")
        #expect(invitation.roleIDs == ["role-editor"])
    }
}
