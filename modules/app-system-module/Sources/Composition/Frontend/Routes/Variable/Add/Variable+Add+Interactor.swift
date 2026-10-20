import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Add {
    enum Interactor {}
}

extension WebAdmin.System.Variable.Add.Interactor {
    protocol Interface: Sendable {

        func add(
            input: SystemVariableAddFormInput
        ) async throws
    }
}
