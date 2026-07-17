import AuthDomain

extension Credential {

    var asDetail: CredentialDetail {
        .init(
            id: id,
            accountID: accountID,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
