import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Search {
    enum Repository {}
}

extension Campaign.Search.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func searchCampaigns(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignQuery(
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(search: search)
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let body = try value.body.json
                    return .init(
                        items: body.data.items.map {
                            .init(
                                id: $0.key,
                                name: $0.name,
                                fromEmail: $0.fromEmail
                            )
                        },
                        pageState: .init(
                            page: body.query.page.number,
                            pageSize: body.query.page.size,
                            total: body.data.total
                        )
                    )
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
