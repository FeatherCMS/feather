import RedirectApplication
import RedirectModule

extension Rule.Remove.Repository {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
