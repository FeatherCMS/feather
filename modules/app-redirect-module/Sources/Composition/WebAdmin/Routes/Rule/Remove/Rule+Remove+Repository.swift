import RedirectModule
extension RedirectModule.Rule.Remove {
    enum Repository {}
}

extension RedirectModule.Rule.Remove.Repository {
    protocol Interface: Sendable {

    func delete(ids: [String]) async throws
    }
}
