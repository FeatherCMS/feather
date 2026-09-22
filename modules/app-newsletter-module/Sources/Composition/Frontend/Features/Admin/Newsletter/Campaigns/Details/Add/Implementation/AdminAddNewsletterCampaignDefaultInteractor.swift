import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignDefaultInteractor:
    AdminAddNewsletterCampaignInteractor
{
    let repository: AdminAddNewsletterCampaignOpenAPIRepository

    func getAddNewsletterCampaign() async throws
        -> AdminAddNewsletterCampaignModel
    {
        .init(
            key: "",
            name: "",
            fromEmail: "",
            error: nil
        )
    }

    func postAddNewsletterCampaign(payload: NewsletterCampaignAddForm)
        async throws -> AdminAddNewsletterCampaignModel
    {
        do {
            try await repository.createNewsletter(
                key: payload.normalizedKey,
                name: payload.normalizedName,
                fromEmail: payload.normalizedFromEmail
            )
            return .init(
                key: "",
                name: "",
                fromEmail: "",
                error: nil
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized:
                throw AdminAddNewsletterCampaignError.unauthorized
            case .forbidden:
                throw AdminAddNewsletterCampaignError.forbidden
            case .conflict:
                throw AdminAddNewsletterCampaignError.conflict
            case .notFound, .failure, .transport:
                throw AdminAddNewsletterCampaignError.unavailable
            }
        }
    }
}
