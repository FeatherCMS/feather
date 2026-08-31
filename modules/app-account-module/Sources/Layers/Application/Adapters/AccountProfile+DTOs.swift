import AccountDomain

extension AccountProfile {
    public var asDetail: AccountProfileDetail {
        .init(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            imageURL: imageURL,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
