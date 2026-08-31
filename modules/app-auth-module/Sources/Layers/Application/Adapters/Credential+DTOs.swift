import AuthDomain

extension Credential {

    var asDetail: CredentialDetail {
        .init(
            id: id,
            userId: userId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
