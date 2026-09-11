import FeatherAdmin
import Foundation

protocol AdminRemoveSystemVariableRepository: Sendable {

    func delete(
        id: String
    ) async throws
}
