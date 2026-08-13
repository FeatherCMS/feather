import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityInteractor: Sendable {

    func execute(
        entity: AdminAddUserIdentityModel
    ) async throws
}
