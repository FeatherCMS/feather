import FeatherAdmin
import Foundation

protocol AdminAddUserRoleInteractor: Sendable {

    func add(
        input: AdminAddUserRoleFormInput
    ) async throws
}
