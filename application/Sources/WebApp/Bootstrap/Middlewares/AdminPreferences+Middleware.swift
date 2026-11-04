import AccountWebAdmin
import AccountAdminAPI
import Environment
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

enum AdminPreferences {}

extension AdminPreferences {
    struct Middleware: RouterMiddleware {
        let environment: AppEnvironment

        func handle(
            _ request: Request,
            context: DefaultRequestContext,
            next:
                @concurrent (Request, DefaultRequestContext) async throws ->
                Response
        ) async throws -> Response {
            guard context.sessionToken != nil, context.account != nil else {
                return try await next(request, context)
            }

            let authenticatedContext = try AuthenticatedRequestContext(
                context: context
            )
            let api = AccountWebAdmin.API.Client(
                environment: environment,
                requestContext: authenticatedContext
            )
            let settings = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.accountSettingsGet(
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let value):
                    return try value.body.json
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

            var context = context
            context.accountSettings = .init(
                language: settings.language,
                timezone: settings.timezone,
                pageSize: settings.pageSize
            )
            return try await next(request, context)
        }
    }
}
