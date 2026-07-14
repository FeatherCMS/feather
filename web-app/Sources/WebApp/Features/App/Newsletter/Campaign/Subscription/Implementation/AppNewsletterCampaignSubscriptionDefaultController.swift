import AppOpenAPI
import Hummingbird

struct AppNewsletterCampaignSubscriptionDefaultController: AppNewsletterCampaignSubscriptionController {
    func subscribe(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let campaignId = try context.requiredParameter("campaignId")
        let form = try await request.decode(
            as: AppNewsletterCampaignSubscriptionForm.self,
            context: context
        )
        let response = try await context.applicationAPI().withOpenAPIRepositoryErrorMapping { client in
            try await client.appContactNewsletterSubscribe(
                path: .init(contactNewsletterId: campaignId),
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
