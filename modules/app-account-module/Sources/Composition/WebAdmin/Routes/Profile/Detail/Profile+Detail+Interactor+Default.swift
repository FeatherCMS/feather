import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Detail.Interactor {

    struct Default:
        Profile.Detail.Interactor.Interface
    {
        let accountProfileRepository:
            any Profile.Detail.Repository.Interface

        func getAccountProfile() async throws -> AdminAccountProfileModel {
            try await accountProfileRepository.get()
        }

        func getProfile(
            account: AccountModel,
            accountProfile: AdminAccountProfileModel
        ) async throws -> Profile.Detail.Model {
            .init(account: account, accountProfile: accountProfile)
        }
    }
}
