import FeatherAdmin
import Foundation

protocol AdminViewUserIdentityRoleRepository: Sendable {

    func names(for ids: [String]) async throws -> [String]
}

