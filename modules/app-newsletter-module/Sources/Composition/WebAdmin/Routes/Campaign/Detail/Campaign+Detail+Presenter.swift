import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Detail {
    enum Presenter {}
}

extension Campaign.Detail.Presenter {
    protocol Interface: Sendable {
        func render(
            id: String,
            item: Campaign.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
