import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Campaign.Search {
    struct Model: Sendable {
        let items: [Campaign.Item]
        let pageState: AdminListPageState
    }
}
