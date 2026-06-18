import Foundation

protocol AdminGetSystemVariableRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel
}
