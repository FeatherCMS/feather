import FeatherAdmin
import Foundation

protocol AdminRemoveUserRoleInteractor: Sendable {

    func names(
        ids: [String]
    ) async throws -> [String]

    func delete(
        ids: [String]
    ) async throws
}
