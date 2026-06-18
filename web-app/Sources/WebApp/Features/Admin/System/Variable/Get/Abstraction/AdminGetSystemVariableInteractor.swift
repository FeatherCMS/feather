import Foundation

protocol AdminGetSystemVariableInteractor: Sendable {

    func execute(
        entity: AdminGetSystemVariableModel
    ) async throws -> SystemVariableDetailsModel
}
