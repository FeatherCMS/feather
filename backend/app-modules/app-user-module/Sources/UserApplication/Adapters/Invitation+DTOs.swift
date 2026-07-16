import UserDomain

extension Invitation {

    var asDetail: InvitationDetail {
        .init(
            id: id,
            accountID: accountID,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
