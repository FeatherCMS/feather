import FeatherWebAdmin
import NewsletterModule

extension Campaign.Subscriber.List.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.List.Repository.Interface

        func list(newsletterId: String, search: String?, page: Int)
            async throws -> AdminListModel<Campaign.Subscriber.List.Item>
        {
            let result = try await repository.search(
                newsletterId: newsletterId,
                search: search,
                page: page
            )
            return .init(
                items: result.items,
                pageState: .init(
                    page: page,
                    pageSize: 20,
                    total: result.total
                )
            )
        }
    }
}
