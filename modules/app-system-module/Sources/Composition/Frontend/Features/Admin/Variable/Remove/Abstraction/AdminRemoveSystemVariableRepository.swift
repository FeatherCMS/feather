import FeatherAdmin
import Foundation

protocol AdminRemoveSystemVariableRepository: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
