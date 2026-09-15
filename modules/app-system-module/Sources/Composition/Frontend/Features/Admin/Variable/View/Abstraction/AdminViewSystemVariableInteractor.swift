import FeatherAdmin
import Foundation

protocol AdminViewSystemVariableInteractor: Sendable {

    func execute(
        entity: AdminViewSystemVariableModel
    ) async throws -> SystemVariableDetailsModel
}
