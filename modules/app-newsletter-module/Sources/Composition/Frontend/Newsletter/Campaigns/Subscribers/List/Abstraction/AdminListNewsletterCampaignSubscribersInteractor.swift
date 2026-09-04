import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListNewsletterCampaignSubscribersInteractor: Sendable {
    func list(newsletterId: String, search: String?) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
}
