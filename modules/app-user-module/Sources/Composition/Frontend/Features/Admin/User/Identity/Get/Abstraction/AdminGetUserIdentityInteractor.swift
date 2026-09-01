import FeatherAdmin
import Foundation

protocol AdminGetUserIdentityInteractor: Sendable {
    func roleNames(for ids: [String]) async throws -> [String]

    func execute(
        id: String
    ) async throws -> AdminGetUserIdentityModel
}
