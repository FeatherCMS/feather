import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignInteractor: Sendable {
    func getAddNewsletterCampaign() async throws
        -> AdminAddNewsletterCampaignModel
    func postAddNewsletterCampaign(payload: NewsletterCampaignAddForm)
        async throws -> AdminAddNewsletterCampaignModel
}
