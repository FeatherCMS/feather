import FeatherAdmin
import Foundation

protocol AdminRemoveSystemVariableInteractor: Sendable {

    func delete(
        ids: [String]
    ) async throws

    func names(ids: [String]) async throws -> [String]
}
