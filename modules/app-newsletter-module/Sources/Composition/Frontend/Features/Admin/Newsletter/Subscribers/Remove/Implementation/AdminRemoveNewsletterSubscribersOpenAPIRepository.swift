import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func names(ids: [String]) async throws -> [String] {
        try await AdminNewsletterSubscribersAPIClient(api: api).names(ids: ids)
    }

    func remove(ids: [String], campaignId: String?) async throws {
        try await AdminNewsletterSubscribersAPIClient(api: api)
            .remove(subscriberIds: ids, campaignId: campaignId)
    }
}
