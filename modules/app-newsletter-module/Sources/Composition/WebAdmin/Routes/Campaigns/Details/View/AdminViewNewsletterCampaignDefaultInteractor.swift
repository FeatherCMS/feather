import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignDefaultInteractor:
    AdminViewNewsletterCampaignInteractor
{
    let repository: AdminViewNewsletterCampaignOpenAPIRepository
    func get(id: String) async throws -> Campaign.Item {
        try await repository.get(id: id)
    }
}
