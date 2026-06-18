import Foundation

protocol AdminGetAuthProfileInteractor: Sendable {

    func getProfile(
        account: AccountModel
    ) async throws -> AdminGetAuthProfileModel
}
