import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Issue.Search.Repository {
    protocol Interface: Sendable {
        func search(
            newsletterId: String,
            page: Int,
            search: String?
        ) async throws -> AdminListModel<Issue.Search.Item>
    }
}

extension Issue.Search {
    enum Repository {}
}
