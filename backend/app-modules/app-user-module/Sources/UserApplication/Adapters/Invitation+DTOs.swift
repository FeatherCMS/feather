import UserDomain

extension Invitation {

    var asDetail: InvitationDetail {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
