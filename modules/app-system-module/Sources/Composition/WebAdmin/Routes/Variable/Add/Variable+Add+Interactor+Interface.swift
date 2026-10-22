import FeatherWebAdmin
import SystemModule

extension Variable.Add.Interactor {
    protocol Interface: Sendable {

        func add(
            input: SystemVariableAddFormInput
        ) async throws
    }
}
