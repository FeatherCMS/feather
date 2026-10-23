import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Remove {
    enum Presenter {}
}

extension Campaign.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse
    }
}
