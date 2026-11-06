import AuthAdminAPI
import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Session.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func search(identityID: String) async throws -> Session.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                var items: [Session.List.Model.Item] = []
                var total = Int.max
                var pageNumber = 1
                var hasMore = true

                while hasMore && items.count < total {
                    let response = try await client.userIdentitySessionQuery(
                        path: .init(userIdentityId: identityID),
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: 100, number: pageNumber),
                                filters: .init()
                            )
                        )
                    )
                    switch response {
                    case .ok(let value):
                        let data = try value.body.json.data
                        total = data.total
                        hasMore = !data.items.isEmpty
                        items.append(
                            contentsOf: data.items.map {
                                .init(
                                    id: $0.id,
                                    authenticationType: $0.authenticationType,
                                    authenticationReference: $0
                                        .authenticationReference,
                                    expiresAt: $0.expiresAt,
                                    isPersistent: $0.isPersistent,
                                    createdAt: $0.createdAt,
                                    updatedAt: $0.updatedAt
                                )
                            }
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
                    pageNumber += 1
                }

                return .init(identityID: identityID, items: items)
            }
        }
    }
}
