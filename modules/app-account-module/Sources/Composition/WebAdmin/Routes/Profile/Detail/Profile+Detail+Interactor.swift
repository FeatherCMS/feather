import AccountDomain
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Detail {
    enum Interactor {}
}

extension Profile.Detail.Interactor {

    protocol Interface: Sendable {
        func getProfile() async throws -> Profile.WebAdminModel

        func getProfile(
            account: AccountModel,
            profile: Profile.WebAdminModel
        ) async throws -> Profile.Detail.Model
    }
}
