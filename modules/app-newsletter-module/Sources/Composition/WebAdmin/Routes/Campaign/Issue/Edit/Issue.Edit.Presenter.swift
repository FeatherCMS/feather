import FeatherWebAdmin
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Edit {
    enum Presenter {}
}

extension Issue.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Issue.Form.Model,
            issueId: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
