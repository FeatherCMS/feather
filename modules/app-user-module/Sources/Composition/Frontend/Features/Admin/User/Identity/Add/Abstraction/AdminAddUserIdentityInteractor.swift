import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityInteractor: Sendable {

    func add(
        input: AdminAddUserIdentityFormInput
    ) async throws
}
