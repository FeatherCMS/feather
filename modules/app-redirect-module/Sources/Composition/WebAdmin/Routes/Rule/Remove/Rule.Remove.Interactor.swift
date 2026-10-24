import RedirectApplication
import RedirectModule

extension Rule.Remove {
    enum Interactor {}
}

extension Rule.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
