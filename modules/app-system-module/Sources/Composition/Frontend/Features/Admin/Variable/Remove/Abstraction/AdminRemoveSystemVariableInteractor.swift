import FeatherAdmin
import Foundation

protocol AdminRemoveSystemVariableInteractor: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
