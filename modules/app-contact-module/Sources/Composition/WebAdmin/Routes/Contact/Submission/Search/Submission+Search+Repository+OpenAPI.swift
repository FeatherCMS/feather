import ContactAdminAPI
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Submission.Search.Repository {
    struct OpenAPI: Interface {
        let api: ContactAdminAPIClient

        func search(page: Int, search: String?) async throws
            -> Submission.Search.Model
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactSubmissionQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: Submission.Search.Router.pageSize,
                                number: page
                            ),
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
                                id: $0.id,
                                formKey: $0.formKey,
                                formName: $0.formName,
                                status: $0.status,
                                createdAt:
                                    DateFormatting
                                    .formatUnixTimestamp($0.createdAt),
                                email: $0.email
                            )
                        },
                        total: body.data.total
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let value):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: value.body
                    )
                }
            }
        }
    }
}
