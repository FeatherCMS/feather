import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Edit.Interactor {

    struct Default:
        Profile.Edit.Interactor.Interface
    {
        let accountProfileRepository:
            any Profile.Edit.Repository.Interface

        func loadProfile(
            account: AccountModel
        ) async throws -> Profile.Edit.Model {
            let accountProfile = try await accountProfileRepository.get()
            return .init(
                id: account.user.id,
                firstName: accountProfile.firstName,
                lastName: accountProfile.lastName,
                profileImageAssetId: accountProfile.profileImageAssetId,
                profileImageAsset: accountProfile.profileImageAsset
            )
        }

        func execute(
            entity: Profile.Edit.Model
        ) async throws {
            try await accountProfileRepository.update(
                profile: entity.accountProfile
            )
        }
    }
}
