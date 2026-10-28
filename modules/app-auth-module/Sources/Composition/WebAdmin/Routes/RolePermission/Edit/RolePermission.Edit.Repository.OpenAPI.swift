import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemModule
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension RolePermission.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let userAPI: UserWebAdmin.API.Client
        let systemAPI: SystemWebAdmin.API.Client
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
            api: API.Client,
            userAPI: UserWebAdmin.API.Client,
            systemAPI: SystemWebAdmin.API.Client
        ) {
            self.api = api
            self.userAPI = userAPI
            self.systemAPI = systemAPI
        }

        func fetchRoles() async throws -> [UserAdminAPI.Components.Schemas
            .UserRoleListItemSchema]
        {
            try await userAPI.withOpenAPIRepositoryErrorMapping { client in
                var roles: [UserAdminAPI.Components.Schemas
                    .UserRoleListItemSchema] = []
                var hasMorePages = true
                var pageNumber = 1

                while hasMorePages {
                    let response =
                        try await client
                        .userRoleQuery(
                            headers: .init(
                                accept: [.init(contentType: .json)]
                            ),
                            body: .json(
                                .init(
                                    page: .init(size: 100, number: pageNumber),
                                    filters: .init(search: nil)
                                )
                            )
                        )

                    switch response {
                    case .ok(let ok):
                        let body = try ok.body.json
                        roles.append(
                            contentsOf: body.data.items.map {
                                .init(
                                    id: $0.id,
                                    key: $0.key,
                                    name: $0.name
                                )
                            }
                        )
                        hasMorePages = roles.count < body.data.total
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await userAPI.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }

                    pageNumber += 1
                }

                return roles
            }
        }

        func fetchPermissions() async throws -> [SystemAdminAPI.Components
            .Schemas
            .SystemPermissionListItemSchema]
        {
            try await systemAPI.withOpenAPIRepositoryErrorMapping { client in
                var permissions: [SystemAdminAPI.Components.Schemas
                    .SystemPermissionListItemSchema] = []
                var hasMorePages = true
                var pageNumber = 1

                while hasMorePages {
                    let response =
                        try await client
                        .systemPermissionQuery(
                            headers: .init(
                                accept: [.init(contentType: .json)]
                            ),
                            body: .json(
                                .init(
                                    page: .init(size: 100, number: pageNumber),
                                    filters: .init(search: nil)
                                )
                            )
                        )

                    switch response {
                    case .ok(let ok):
                        let body = try ok.body.json
                        permissions.append(
                            contentsOf: body.data.items.map {
                                .init(
                                    id: $0.id,
                                    key: $0.key,
                                    name: $0.name,
                                    notes: $0.notes
                                )
                            }
                        )
                        hasMorePages = permissions.count < body.data.total
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await systemAPI.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }

                    pageNumber += 1
                }

                return permissions
            }
        }

        func fetchExistingPairs() async throws -> Set<
            RolePermission.Edit.Pair
        > {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                var pairs: Set<RolePermission.Edit.Pair> = []
                var hasMorePages = true
                var pageNumber = 1

                while hasMorePages {
                    let response =
                        try await client
                        .authRolePermissionQuery(
                            headers: .init(
                                accept: [.init(contentType: .json)]
                            ),
                            body: .json(
                                .init(
                                    page: .init(size: 100, number: pageNumber),
                                    filters: .init(search: nil)
                                )
                            )
                        )

                    switch response {
                    case .ok(let ok):
                        let body = try ok.body.json
                        pairs.formUnion(
                            body.data.items.map {
                                RolePermission.Edit.Pair(
                                    roleId: $0.roleId,
                                    permissionId: $0.permissionId
                                )
                            }
                        )
                        hasMorePages = pairs.count < body.data.total
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

                return pairs
            }
        }

        func delete(
            pair: RolePermission.Edit.Pair
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authRolePermissionRemove(
                    body: .json(
                        .init(
                            ids: ["\(pair.roleId):\(pair.permissionId)"]
                        )
                    )
                )
                switch response {
                case .noContent:
                    break
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

        func create(
            pair: RolePermission.Edit.Pair
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
