import FeatherAdmin
import Foundation

protocol AdminViewSystemVariableRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel
}
