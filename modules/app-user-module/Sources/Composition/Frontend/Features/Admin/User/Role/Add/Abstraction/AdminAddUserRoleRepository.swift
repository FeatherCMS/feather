import FeatherAdmin
import Foundation

protocol AdminAddUserRoleRepository: Sendable {

    func create(
        payload: UserRoleAddFormPayloadModel
    ) async throws
}
