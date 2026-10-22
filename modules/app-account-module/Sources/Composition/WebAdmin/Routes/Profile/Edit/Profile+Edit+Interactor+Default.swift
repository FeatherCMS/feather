import AccountModule
import FeatherWebAdmin
import FeatherWebShared

extension Profile.Edit.Interactor {

    struct Default:
        Profile.Edit.Interactor.Interface
    {
        let profileRepository:
            any Profile.Edit.Repository.Interface

        func loadProfile(
            account: AccountModel
        ) async throws -> Profile.Edit.Model {
            let profile = try await profileRepository.get()
            return .init(
                id: account.user.id,
                firstName: profile.firstName,
                lastName: profile.lastName,
                profileImageAssetId: profile.profileImageAssetId,
                profileImageAsset: profile.profileImageAsset
            )
        }

        func execute(
            entity: Profile.Edit.Model
        ) async throws {
            try await profileRepository.update(
                profile: entity.profile
            )
        }
    }
}
