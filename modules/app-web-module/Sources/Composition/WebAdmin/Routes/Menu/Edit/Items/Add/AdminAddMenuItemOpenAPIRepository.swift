import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminAddMenuItemOpenAPIRepository: AdminAddMenuItemRepository {
    let api: API.Client

    func create(
        menuId: String,
        input: MenuItemFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.menuItemCreate(
                path: .init(menuId: menuId),
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
