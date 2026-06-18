import Foundation

protocol AdminEditAuthProfileInteractor: Sendable {

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAuthProfileModel

    func execute(
        entity: AdminEditAuthProfileModel
    ) async throws
}
