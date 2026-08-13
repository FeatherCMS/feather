import FeatherAdmin
import Foundation

protocol AdminRemoveUserIdentityRepository: Sendable {

    func delete(
        id: String
    ) async throws
}
