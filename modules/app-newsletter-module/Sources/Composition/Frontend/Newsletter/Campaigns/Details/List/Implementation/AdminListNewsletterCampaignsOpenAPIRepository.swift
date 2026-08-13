import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignsOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await AdminNewsletterCampaignAPIClient(api: api).list()
    }
}
