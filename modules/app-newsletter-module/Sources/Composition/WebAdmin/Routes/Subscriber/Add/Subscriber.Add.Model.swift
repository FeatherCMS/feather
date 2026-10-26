import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add {
    struct Model: Sendable {
        let email: String
        let firstName: String
        let lastName: String
        let selectedCampaignIds: Set<String>
        let campaigns: [Subscriber.List.Model.Campaign]
        let error: String?
    }
}
