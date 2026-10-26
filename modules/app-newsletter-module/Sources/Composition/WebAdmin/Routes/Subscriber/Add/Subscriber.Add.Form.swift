import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add {
    struct Form: Decodable, Sendable {
        let email: String
        let firstName: String
        let lastName: String
        let campaignIds: [String]?

        var selectedCampaignIds: Set<String> {
            Set((campaignIds ?? []).filter { !$0.isEmpty })
        }
    }
}
