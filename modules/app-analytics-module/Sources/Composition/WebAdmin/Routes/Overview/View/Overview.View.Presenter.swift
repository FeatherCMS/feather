import FeatherWebAdmin

extension Overview.View {
    enum Presenter {}
}

extension Overview.View.Presenter {
    protocol Interface: Sendable {
        func renderOverview(
            model: Overview.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
