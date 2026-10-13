import FeatherAdmin

protocol AdminViewAccountProfileInteractor: Sendable {
    func getAccountProfile() async throws -> AdminAccountProfileModel

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) async throws -> AdminViewAccountProfileModel
}
