import FeatherAdmin
import Foundation

protocol AdminRemoveSystemVariableRepository: Sendable {

    func delete(
        ids: [String]
    ) async throws

    func names(ids: [String]) async throws -> [String]
}
