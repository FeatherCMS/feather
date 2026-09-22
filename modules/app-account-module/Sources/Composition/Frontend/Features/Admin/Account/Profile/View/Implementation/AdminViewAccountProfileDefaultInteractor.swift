import FeatherAdmin

struct AdminViewAccountProfileDefaultInteractor:
    AdminViewAccountProfileInteractor
{
    let accountProfileRepository: any AdminViewAccountProfileRepository

    func getAccountProfile() async throws -> AdminAccountProfileModel {
        try await accountProfileRepository.get()
    }

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) async throws -> AdminViewAccountProfileModel {
        .init(account: account, accountProfile: accountProfile)
    }
}
