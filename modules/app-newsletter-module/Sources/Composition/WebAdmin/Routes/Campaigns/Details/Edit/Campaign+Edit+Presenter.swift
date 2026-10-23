import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Edit {
    enum Presenter {}
}

extension Campaign.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            item: Campaign.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderEditError(
            id: String,
            item: Campaign.Item,
            error: Campaign.Edit.WebError,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Campaign.Edit.WebError
        ) async throws -> HTMLResponse
    }
}
