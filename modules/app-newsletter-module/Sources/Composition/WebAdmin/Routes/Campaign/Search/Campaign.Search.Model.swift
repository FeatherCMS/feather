import FeatherWebAdmin
import NewsletterModule
import NewsletterApplication

extension Campaign.Search {
    struct Model: Sendable {
        let items: [Campaign.Item]
        let pageState: AdminListPageState
    }
}
