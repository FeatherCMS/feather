import FeatherWebAdmin
import NewsletterModule

extension Campaign.Search {
    enum Presenter {}
}

extension Campaign.Search.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Campaign.Search.Model,
            isPicker: Bool,
            error: String?,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse
    }
}
