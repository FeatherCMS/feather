import Foundation

protocol AdminRemoveSystemVariableRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel

    func delete(
        id: String
    ) async throws
}
