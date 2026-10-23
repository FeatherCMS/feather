import FeatherWebAdmin
import NewsletterModule

extension Campaign.Search {
    struct Model: Sendable {
        let items: [Campaign.Item]
        let pageState: AdminListPageState
    }
}
