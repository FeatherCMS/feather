import Foundation

protocol AdminRemoveSystemVariableInteractor: Sendable {

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel

    func delete(
        id: String
    ) async throws
}
