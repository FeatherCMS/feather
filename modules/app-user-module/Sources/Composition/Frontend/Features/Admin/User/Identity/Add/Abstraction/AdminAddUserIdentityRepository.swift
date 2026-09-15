import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityRepository: Sendable {

    func create(
        payload: UserIdentityAddFormPayloadModel
    ) async throws
}
