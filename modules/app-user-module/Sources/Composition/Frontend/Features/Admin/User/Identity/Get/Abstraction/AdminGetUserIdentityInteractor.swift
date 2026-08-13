import FeatherAdmin
import Foundation

protocol AdminGetUserIdentityInteractor: Sendable {

    func execute(
        id: String
    ) async throws -> AdminGetUserIdentityModel
}
