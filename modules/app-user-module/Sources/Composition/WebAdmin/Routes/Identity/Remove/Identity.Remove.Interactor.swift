import FeatherWebAdmin
import UserModule

extension Identity.Remove {
    enum Interactor {}
}

extension Identity.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
