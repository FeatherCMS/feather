import Foundation

protocol AdminEditUserAccountInteractor: Sendable {

    func loadAccount(
        id: String
    ) async throws -> AdminEditUserAccountModel

    func loadRoleOptions() async throws
        -> [AdminEditUserAccountRoleOptionModel]

    func update(
        entity: AdminEditUserAccountModel
    ) async throws
}
