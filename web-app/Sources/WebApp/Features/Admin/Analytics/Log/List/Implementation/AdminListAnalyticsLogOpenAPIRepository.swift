import AdminOpenAPI
import Hummingbird

struct AdminListAnalyticsLogOpenAPIRepository:
    AdminListAnalyticsLogRepository
{
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to view analytics logs."
    private let forbiddenMessage =
        "Your account cannot access analytics logs."

    init(api: AdminAPI) {
        self.api = api
    }

    func listAnalyticsLogs(
        page: Int,
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?
    ) async throws -> AdminListAnalyticsLogModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .analyticsLogSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(
                                search: search ?? "",
                                source: source ?? "",
                                method: method ?? "",
                                responseCode: responseCode
                            )
                        )
                    )
                )

            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                return .init(
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    pageSize: body.query.page.size,
                    source: body.query.filters.source ?? "",
                    method: body.query.filters.method ?? "",
                    responseCode: body.query.filters.responseCode.map(
                        String.init
                    )
                        ?? ""
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: forbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
