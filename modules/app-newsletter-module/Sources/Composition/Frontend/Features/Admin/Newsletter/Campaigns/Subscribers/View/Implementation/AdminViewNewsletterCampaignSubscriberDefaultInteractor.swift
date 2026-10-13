import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriberDefaultInteractor:
    AdminViewNewsletterCampaignSubscriberInteractor
{
    let repository: AdminViewNewsletterCampaignSubscriberOpenAPIRepository
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await repository.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
}
