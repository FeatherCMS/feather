import FeatherAdmin

struct AdminViewAccountProfileModel: Sendable {
    let id: String
    let email: String
    let roles: [String]
    let permissions: [String]
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
    let profileImageAsset: NewAdminMediaAsset?

    init(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) {
        self.id = account.user.id
        self.email = account.user.email
        self.roles = account.roles
        self.permissions = account.permissions
        self.firstName = accountProfile.firstName
        self.lastName = accountProfile.lastName
        self.profileImageAssetId = accountProfile.profileImageAssetId
        self.profileImageAsset = accountProfile.profileImageAsset
    }
}
