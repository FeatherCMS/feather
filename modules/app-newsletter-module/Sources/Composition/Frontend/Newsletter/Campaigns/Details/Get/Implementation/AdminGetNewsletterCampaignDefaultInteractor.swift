import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterCampaignDefaultInteractor:
    AdminGetNewsletterCampaignInteractor
{
    let repository: AdminGetNewsletterCampaignOpenAPIRepository
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await repository.get(id: id)
    }
}
