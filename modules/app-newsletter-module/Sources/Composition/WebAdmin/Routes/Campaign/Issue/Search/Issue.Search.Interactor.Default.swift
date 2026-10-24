import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Issue.Search.Interactor {
    struct Default: Interface {
        let repository: any Issue.Search.Repository.Interface

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
