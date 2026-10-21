import FeatherWebAdmin
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectModule
import RedirectApplication

extension RedirectModule.Rule.View.Repository {
    struct OpenAPI: Interface {
    let api: API.Client

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .redirectRuleGet(
                    path: .init(redirectRuleId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let rule = try okResponse.body.json
                return .init(
                    id: rule.id,
                    source: rule.source,
                    destination: rule.destination,
                    statusCode: RedirectModule.Rule.StatusCode(rawValue: rule.statusCode)!,
                    notes: rule.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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
