import AccountDomain
import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail {

    struct Model: Sendable {
        let id: String
        let email: String
        let roles: [String]
        let permissions: [String]
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let profileImageAsset: AdminMediaAsset?

        init(
            account: AccountModel,
            profile: Profile.Remote.Model
        ) {
            self.id = account.user.id
            self.email = account.user.email
            self.roles = account.roles
            self.permissions = account.permissions
            self.firstName = profile.firstName
            self.lastName = profile.lastName
            self.profileImageAssetId = profile.profileImageAssetId
            self.profileImageAsset = profile.profileImageAsset
        }
    }
}
