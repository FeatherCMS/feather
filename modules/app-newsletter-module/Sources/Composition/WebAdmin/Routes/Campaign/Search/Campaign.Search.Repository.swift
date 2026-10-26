import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Search.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model
    }
}
