import AuthDomain

extension Credential {

    var asDetail: CredentialDetail {
        .init(
            id: id,
            userId: userId,
            email: email,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
