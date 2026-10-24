extension Contact.Overview {
    enum Interactor {}
}

extension Contact.Overview.Interactor {
    protocol Interface: Sendable {
        func getOverview() async throws -> Contact.Overview.Model
    }
}
