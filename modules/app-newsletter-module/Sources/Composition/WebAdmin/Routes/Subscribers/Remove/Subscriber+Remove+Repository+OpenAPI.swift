import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Remove {
    enum Repository {}
}

extension Subscriber.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(ids: [String], campaignId: String?) async throws {
            try await Subscriber.List.Repository.Client(api: api)
                .remove(subscriberIds: ids, campaignId: campaignId)
        }
    }
}
