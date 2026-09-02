import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminEditAuthAccessControlOpenAPIRepository:
    AdminEditAuthAccessControlRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient
    let systemAPI: SystemAdminAPIClient
    private let rolesUnauthorizedMessage =
        "Please sign in again to view user roles."
    private let rolesForbiddenMessage =
        "Your identity cannot access user roles."
    private let permissionsUnauthorizedMessage =
        "Please sign in again to view system permissions."
    private let permissionsForbiddenMessage =
        "Your identity cannot access system permissions."

    private let rolePermissionLoadError =
        "Could not load existing role-permission assignments."
    private let deleteUnauthorizedMessage =
        "Please sign in again to remove this role-permission assignment."
    private let deleteForbiddenMessage =
        "Your identity cannot remove this role-permission assignment."
    private let createUnauthorizedMessage =
        "Please sign in again to create this role-permission assignment."
    private let createForbiddenMessage =
        "Your identity cannot create this role-permission assignment."

    init(
        api: AuthAdminAPIClient,
        userAPI: UserAdminAPIClient,
        systemAPI: SystemAdminAPIClient
    ) {
        self.api = api
        self.userAPI = userAPI
        self.systemAPI = systemAPI
    }

    func fetchRoles() async throws -> [UserAdminAPI.Components.Schemas
        .UserRoleListItemSchema]
    {
        try await userAPI.withOpenAPIRepositoryErrorMapping { client in
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
                throw try await userAPI.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func fetchPermissions() async throws -> [SystemAdminAPI.Components.Schemas
        .SystemPermissionListItemSchema]
    {
        try await systemAPI.withOpenAPIRepositoryErrorMapping { client in
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
                throw try await systemAPI.failure(
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
                .authRolePermissionSearch(
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
            let response = try await client.authRolePermissionDelete(
                body: .json(
                    .init(
                        ids: ["\(pair.roleId):\(pair.permissionId)"],
                        results: false,
                        summary: true
                    )
                )
            )
            switch response {
            case .ok:
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
                .authRolePermissionCreate(
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
