import AccountDomain
import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail.Interactor {

    struct Default:
        Profile.Detail.Interactor.Interface
    {
        let profileRepository: any Profile.Detail.Repository.Interface

        func getProfile() async throws -> Profile.Remote.Model {
            try await profileRepository.get()
        }

        func getProfile(
            account: AccountModel,
            profile: Profile.Remote.Model
        ) async throws -> Profile.Detail.Model {
            .init(account: account, profile: profile)
        }
    }
}
