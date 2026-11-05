import FeatherWebAdmin

extension Contact.Overview {
    enum Presenter {}
}

extension Contact.Overview.Presenter {
    protocol Interface: Sendable {
        func renderOverview(
            model: Contact.Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
