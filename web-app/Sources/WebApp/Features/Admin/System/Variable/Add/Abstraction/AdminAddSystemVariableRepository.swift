import Foundation

protocol AdminAddSystemVariableRepository: Sendable {

    func create(
        input: SystemVariableFormInput
    ) async throws
}
