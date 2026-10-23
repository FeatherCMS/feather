import FeatherWebAdmin

extension Overview {
    enum Presenter {}
}

extension Overview.Presenter {
    protocol Interface: Sendable {
        func renderOverview(
            model: Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
