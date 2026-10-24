import ContactApplication
import ContactModule

extension ContactModule.Form.Remove {
    enum Interactor {}
}

extension ContactModule.Form.Remove.Interactor {
    protocol Interface: Sendable {
        func remove(keys: [String]) async throws
    }
}
