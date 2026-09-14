import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignSubscribersInteractor: Sendable {
    func list(newsletterId: String, search: String?) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
}
