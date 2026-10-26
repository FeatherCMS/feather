import FeatherWebAdmin
import FeatherWebShared

extension Overview {
    enum Presenter {}
}

extension Overview.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
