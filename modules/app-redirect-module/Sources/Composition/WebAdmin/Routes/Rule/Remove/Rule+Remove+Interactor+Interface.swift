import RedirectApplication
import RedirectModule

extension Rule.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
