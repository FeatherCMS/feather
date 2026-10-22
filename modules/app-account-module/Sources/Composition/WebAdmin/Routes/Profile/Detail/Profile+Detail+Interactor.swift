import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail.Interactor {

    protocol Interface: Sendable {
        func getAccountProfile() async throws -> AdminAccountProfileModel

        func getProfile(
            account: AccountModel,
            accountProfile: AdminAccountProfileModel
        ) async throws -> Profile.Detail.Model
    }
}
