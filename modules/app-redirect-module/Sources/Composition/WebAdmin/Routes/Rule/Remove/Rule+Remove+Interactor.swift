import RedirectApplication
import RedirectModule
extension RedirectModule.Rule.Remove {
    enum Interactor {}
}

extension RedirectModule.Rule.Remove.Interactor {
    protocol Interface: Sendable {

    func delete(ids: [String]) async throws
    }
}
