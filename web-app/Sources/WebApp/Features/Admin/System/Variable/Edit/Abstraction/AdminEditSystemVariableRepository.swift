import Foundation

protocol AdminEditSystemVariableRepository: Sendable {

    func load(
        id: String
    ) async throws -> SystemVariableDetailsModel

    func update(
        id: String,
        input: SystemVariableFormInput
    ) async throws
}
