import Foundation

protocol AdminAddUserRoleInteractor: Sendable {

    func execute(
        entity: AdminAddUserRoleModel
    ) async throws
}
