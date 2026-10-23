import AccountModule
import AccountDomain
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail.Interactor {

    struct Default:
        Profile.Detail.Interactor.Interface
    {
        let profileRepository:
            any Profile.Detail.Repository.Interface

        func getProfile() async throws -> Profile.WebAdminModel {
            try await profileRepository.get()
        }

        func getProfile(
            account: AccountModel,
            profile: Profile.WebAdminModel
        ) async throws -> Profile.Detail.Model {
            .init(account: account, profile: profile)
        }
    }
}
