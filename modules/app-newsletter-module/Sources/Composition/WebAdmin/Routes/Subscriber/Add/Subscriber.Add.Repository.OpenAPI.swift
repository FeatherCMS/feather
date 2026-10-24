import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add {
    enum Repository {}
}

extension Subscriber.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func listCampaigns() async throws
            -> [Subscriber.List.Model.Campaign]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignList()
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        .init(id: $0.key, name: $0.name)
                    }
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

        func create(
            form: Subscriber.Add.Form,
            campaigns: [Subscriber.List.Model.Campaign]
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                for campaign in campaigns
                where form.selectedCampaignIds.contains(campaign.id) {
                    let response =
                        try await client.newsletterSubscriberCreate(
                            path: .init(newsletterCampaignKey: campaign.id),
                            body: .json(
                                .init(
                                    email: form.email,
                                    firstName: form.firstName,
                                    lastName: form.lastName,
                                    status: "subscribed"
                                )
                            )
                        )
                    switch response {
                    case .created: continue
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
}
