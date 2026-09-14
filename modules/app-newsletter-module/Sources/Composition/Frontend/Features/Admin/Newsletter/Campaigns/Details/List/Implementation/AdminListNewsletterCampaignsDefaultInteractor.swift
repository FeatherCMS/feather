import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignsDefaultInteractor:
    AdminListNewsletterCampaignsInteractor
{
    let repository: AdminListNewsletterCampaignsOpenAPIRepository

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await repository.list()
    }
}
