import FeatherWebAdmin
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Remove {
    enum Presenter {}
}

extension Issue.Remove.Presenter {
    protocol Interface: Sendable {
        func render(
            newsletterId: String,
            item: AdminRemoveItemContext
        ) async throws -> HTMLResponse
    }
}
