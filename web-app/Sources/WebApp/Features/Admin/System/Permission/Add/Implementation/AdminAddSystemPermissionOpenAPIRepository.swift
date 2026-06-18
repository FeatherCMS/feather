import AdminOpenAPI
import Hummingbird

struct AdminAddSystemPermissionOpenAPIRepository:
    AdminAddSystemPermissionRepository
{
    let api: AdminAPI

    func create(
        entity: AdminAddSystemPermissionModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemPermissionCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            name: entity.name,
                            notes: entity.notes
                        )
                    )
                )

            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this system permission."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create system permissions."
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
