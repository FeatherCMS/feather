import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAppAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AppNewsletterCampaignSubscriptionDefaultController:
    AppNewsletterCampaignSubscriptionController
{
    func subscribe(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let campaignId = try context.requiredParameter("campaignId")
        let form = try await request.decode(
            as: AppNewsletterCampaignSubscriptionForm.self,
            context: context
        )
        let response = try await context.newsletterApplicationAPI()
            .withOpenAPIRepositoryErrorMapping { client in
                try await client.appNewsletterCampaignSubscribe(
                    path: .init(newsletterCampaignId: campaignId),
                    body: .json(.init(email: form.email))
                )
            }
        guard case .noContent = response else {
            throw HTTPError(.badRequest)
        }
        return Response(
            status: .seeOther,
            headers: [.location: request.headers[.referer] ?? "/"]
        )
    }
}
