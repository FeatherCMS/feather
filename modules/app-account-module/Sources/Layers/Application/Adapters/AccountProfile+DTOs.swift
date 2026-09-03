import AccountDomain

extension AccountProfile {
    public var asDetail: AccountProfileDetail {
        .init(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
