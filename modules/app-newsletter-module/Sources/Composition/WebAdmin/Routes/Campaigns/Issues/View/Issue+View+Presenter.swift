import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Issue.View {
    enum Presenter {}
}

extension Issue.View.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Issue.Form.Model,
            issueId: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
