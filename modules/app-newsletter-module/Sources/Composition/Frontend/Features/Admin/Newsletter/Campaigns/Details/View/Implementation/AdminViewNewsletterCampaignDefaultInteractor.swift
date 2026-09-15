import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignDefaultInteractor:
    AdminViewNewsletterCampaignInteractor
{
    let repository: AdminViewNewsletterCampaignOpenAPIRepository
    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await repository.get(id: id)
    }
}
