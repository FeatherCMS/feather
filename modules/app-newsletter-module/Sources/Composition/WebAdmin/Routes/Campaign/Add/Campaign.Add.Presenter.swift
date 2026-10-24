import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    enum Presenter {}
}

extension Campaign.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Campaign.Add.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderAddError(
            input: Campaign.Add.Form,
            error: Campaign.Add.WebError,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
