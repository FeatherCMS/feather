import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditAuthAccessControlOpenAPIRepository:
    AdminEditAuthAccessControlRepository
{
    let api: AdminAPI
    private let rolesUnauthorizedMessage =
        "Please sign in again to view user roles."
    private let rolesForbiddenMessage =
        "Your account cannot access user roles."
    private let permissionsUnauthorizedMessage =
        "Please sign in again to view system permissions."
    private let permissionsForbiddenMessage =
        "Your account cannot access system permissions."

    private let rolePermissionLoadError =
        "Could not load existing role-permission assignments."
    private let deleteUnauthorizedMessage =
        "Please sign in again to remove this role-permission assignment."
    private let deleteForbiddenMessage =
        "Your account cannot remove this role-permission assignment."
    private let createUnauthorizedMessage =
        "Please sign in again to create this role-permission assignment."
    private let createForbiddenMessage =
        "Your account cannot create this role-permission assignment."

    func fetchRoles() async throws -> [Components.Schemas
        .UserRoleListItemSchema]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 300, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )

            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: rolesUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: rolesForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func fetchPermissions(  // empty
        ) async throws -> [Components.Schemas.SystemPermissionListItemSchema]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemPermissionSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 300, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )

            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: permissionsUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: permissionsForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func fetchExistingPairs() async throws -> Set<
        AdminEditAuthAccessControlPair
    > {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRolePermissionSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 10_000, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )

            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return Set(
                    body.data.items.map {
                        AdminEditAuthAccessControlPair(
                            roleId: $0.roleId,
                            permissionId: $0.permissionId
                        )
                    }
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: rolePermissionLoadError
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: rolePermissionLoadError
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        pair: AdminEditAuthAccessControlPair
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRolePermissionDelete(
                    path: .init(
                        userRoleId: pair.roleId,
                        systemPermissionId: pair.permissionId
                    )
                )
            switch response {
            case .noContent:
                break
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: deleteForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func create(
        pair: AdminEditAuthAccessControlPair
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRolePermissionCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            roleId: pair.roleId,
                            permissionId: pair.permissionId
                        )
                    )
                )
            switch response {
            case .created:
                break
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: createUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: createForbiddenMessage
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
