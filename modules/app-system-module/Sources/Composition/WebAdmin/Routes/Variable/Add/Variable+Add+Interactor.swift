import FeatherWebAdmin
import SystemModule

extension Variable.Add {
    enum Interactor {}
}

extension Variable.Add.Interactor {
    protocol Interface: Sendable {

        func add(
            input: SystemVariableAddFormInput
        ) async throws
    }
}
