import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterSubscribersOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func campaigns() async throws -> [AdminNewsletterSubscriberCampaign] {
        try await AdminNewsletterSubscribersAPIClient(api: api).campaigns()
    }

    func list() async throws -> [AdminNewsletterSubscriberListItem] {
        try await AdminNewsletterSubscribersAPIClient(api: api).list()
    }
}
