import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveNewsletterSubscribersOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func remove(ids: [String], campaignId: String?) async throws {
        try await AdminNewsletterSubscribersAPIClient(api: api)
            .remove(subscriberIds: ids, campaignId: campaignId)
    }
}
