import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Issue.Search.Interactor {
    struct Default: Interface {
        let repository: Issue.Search.Repository.OpenAPI

        func search(
            newsletterId: String,
            page: Int,
            search: String?
        ) async throws -> AdminListModel<Issue.Search.Item> {
            try await repository.search(
                newsletterId: newsletterId,
                page: page,
                search: search
            )
        }
    }
}
