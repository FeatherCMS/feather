import Foundation

protocol AdminAddSystemVariableInteractor: Sendable {

    func execute(
        input: SystemVariableFormInput
    ) async throws
}
