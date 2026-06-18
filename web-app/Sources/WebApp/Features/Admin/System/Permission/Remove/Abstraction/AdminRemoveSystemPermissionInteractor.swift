import Foundation

protocol AdminRemoveSystemPermissionInteractor: Sendable {

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel

    func delete(
        id: String
    ) async throws
}
