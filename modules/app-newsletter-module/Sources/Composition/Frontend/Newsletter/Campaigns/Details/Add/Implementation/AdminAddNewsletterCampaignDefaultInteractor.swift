import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignDefaultInteractor:
    AdminAddNewsletterCampaignInteractor
{
    let repository: AdminAddNewsletterCampaignOpenAPIRepository

    func getAddNewsletterCampaign() async throws
        -> AdminAddNewsletterCampaignModel
    {
        .init(name: "", fromEmail: "", error: nil)
    }

    func postAddNewsletterCampaign(payload: NewsletterCampaignAddForm)
        async throws -> AdminAddNewsletterCampaignModel
    {
        do {
            try await repository.createNewsletter(
                name: payload.normalizedName,
                fromEmail: payload.normalizedFromEmail
            )
            return .init(name: "", fromEmail: "", error: nil)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                name: payload.name,
                fromEmail: payload.fromEmail,
                error: error.errorDescription
            )
        }
    }
}
