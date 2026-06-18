import Foundation

struct AdminGetAuthProfileDefaultInteractor: AdminGetAuthProfileInteractor {

    func getProfile(
        account: AccountModel
    ) async throws -> AdminGetAuthProfileModel {
        .init(account: account)
    }
}
