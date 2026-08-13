import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityRepository: Sendable {

    func create(
        payload: UserIdentityFormPayloadModel
    ) async throws
}
