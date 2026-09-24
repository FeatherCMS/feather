import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminAddWebMenuItemOpenAPIRepository: AdminAddWebMenuItemRepository {
    let api: WebAdminAPIClient

    func create(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuItemCreate(
                path: .init(webMenuId: menuId),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        label: input.normalizedLabel,
                        url: input.normalizedURL,
                        priority: input.parsedPriority ?? 0,
                        isBlank: input.isBlank.value,
                        permission: input.permission,
                        authentication: input.normalizedAuthentication,
                        notes: input.normalizedNotes
                    )
                )
            )

            switch response {
            case .created:
                return
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
