import FeatherAdmin
import Foundation

protocol AdminRemoveUserIdentityInteractor: Sendable {

    func execute(
        entity: AdminRemoveUserIdentityModel
    ) async throws
}
