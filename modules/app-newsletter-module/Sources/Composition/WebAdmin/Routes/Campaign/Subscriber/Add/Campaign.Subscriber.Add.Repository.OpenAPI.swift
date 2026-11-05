import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Subscriber.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(newsletterId: String, form: Campaign.Subscriber.Form.Input)
            async throws
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterSubscriberCreate(
                    path: .init(newsletterCampaignId: newsletterId),
                    body: .json(
                        .init(
                            email: form.email,
                            firstName: form.firstName,
                            lastName: form.lastName,
                            status: form.status
                        )
                    )
                )
                switch response {
                case .created: return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
