import FeatherAdmin

protocol AdminEditAccountProfileInteractor: Sendable {

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAccountProfileModel

    func execute(
        entity: AdminEditAccountProfileModel
    ) async throws
}
