import FeatherWebAdmin
import UserModule

extension Role.Add {
    enum Interactor {}
}

extension Role.Add.Interactor {
    protocol Interface: Sendable {

        func add(
            input: Role.Add.Form.Input
        ) async throws
    }
}
