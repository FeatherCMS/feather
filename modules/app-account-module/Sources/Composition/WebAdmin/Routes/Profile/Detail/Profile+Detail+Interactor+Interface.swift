import AccountModule
import AccountDomain
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail.Interactor {

    protocol Interface: Sendable {
        func getProfile() async throws -> Profile.Model

        func getProfile(
            account: AccountModel,
            profile: Profile.Model
        ) async throws -> Profile.Detail.Model
    }
}
