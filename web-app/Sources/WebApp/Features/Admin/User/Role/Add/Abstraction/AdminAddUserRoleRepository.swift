import Foundation

protocol AdminAddUserRoleRepository: Sendable {

    func create(
        payload: UserRoleFormPayloadModel
    ) async throws
}
