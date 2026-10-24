import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List {
    struct Model: Sendable {
        let items: [Item]
        let campaigns: [Campaign]
        let search: String
        let campaignId: String
        let pageState: AdminListPageState
    }
}
