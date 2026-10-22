import FeatherWebAdmin
import UserModule

extension Role.Add.Interactor {
    protocol Interface: Sendable {

        func add(
            input: Role.Add.FormInput
        ) async throws
    }
}
