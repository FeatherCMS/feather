public import AuthAdminAPI
public import AuthApplication
public import AuthModule
public import FeatherApplication
import Foundation

extension AdminAPIGateway {
    public func mapSortDirection(
        _ direction: AuthAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    public func map(
        _ page: AuthAdminAPI.Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        .init(size: page?.size ?? 20, number: page?.number ?? 1)
    }

    public func map(
        _ item: Session.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.UserAuthSessionListItemSchema {
        .init(
            id: item.id,
            authenticationType: item.authenticationType,
            authenticationReference: item.authenticationReference,
            expiresAt: item.expiresAt,
            isPersistent: item.isPersistent,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthRolePermissionListItemSearchRequestQuerySchema
    ) -> RolePermission.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: RolePermission.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .roleId: field = .roleId
                    case .permissionId: field = .permissionId
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    public func responseQuery(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthRolePermissionListItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthRolePermissionListItemSearchResponseQuerySchema
    {
        let page = map(query.page).normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    AuthAdminAPI.Components.Schemas
                        .AuthRolePermissionListItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .roleId: field = .roleId
                case .permissionId: field = .permissionId
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthRolePermissionListItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    public func map(
        _ detail: RolePermission.Add.Output
    ) -> AuthAdminAPI.Components.Schemas.AuthRolePermissionDetailSchema {
        .init(roleId: detail.roleId, permissionId: detail.permissionId)
    }

    public func map(
        _ item: RolePermission.Search.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthRolePermissionListItemSchema {
        .init(roleId: item.roleId, permissionId: item.permissionId)
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthMagicLinkListItemSearchRequestQuerySchema
    ) -> MagicLink.List.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: MagicLink.List.Input.Query.Sort.Field
                    switch rule.field {
                    case .id, .credentialId, .token, .expiresAt, .isPersistent,
                        .isUsed:
                        field = .id
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    public func responseQuery(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthMagicLinkListItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthMagicLinkListItemSearchResponseQuerySchema
    {
        let page =
            Search.Page(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            )
            .normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    AuthAdminAPI.Components.Schemas
                        .AuthMagicLinkListItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id: field = .id
                case .credentialId: field = .credentialId
                case .token: field = .token
                case .expiresAt: field = .expiresAt
                case .isPersistent: field = .isPersistent
                case .isUsed: field = .isUsed
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthMagicLinkListItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                userId: query.filters.userId
            )
        )
    }

    public func map(
        _ detail: MagicLink.Detail.Output
    ) -> AuthAdminAPI.Components.Schemas.AuthMagicLinkDetailSchema {
        .init(
            id: detail.id,
            credentialId: detail.authEmailId,
            token: detail.token,
            expiresAt: detail.expiresAt.timeIntervalSince1970,
            isPersistent: detail.isPersistent,
            isUsed: detail.isUsed
        )
    }

    public func map(
        _ item: MagicLink.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema {
        .init(
            id: item.id,
            credentialId: item.authEmailId,
            token: item.token,
            expiresAt: item.expiresAt.timeIntervalSince1970,
            isPersistent: item.isPersistent,
            isUsed: item.isUsed
        )
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthCredentialListItemSearchRequestQuerySchema
    ) -> Credential.List.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Credential.List.Input.Query.Sort.Field
                    switch rule.field {
                    case .userId: field = .userId
                    case .email: field = .email
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    public func responseQuery(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthCredentialListItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthCredentialListItemSearchResponseQuerySchema
    {
        let page =
            Search.Page(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            )
            .normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    AuthAdminAPI.Components.Schemas
                        .AuthCredentialListItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .userId: field = .userId
                case .email: field = .email
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthCredentialListItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                userId: query.filters.userId
            )
        )
    }

    public func map(
        _ detail: Credential.Detail.Output
    ) -> AuthAdminAPI.Components.Schemas.AuthCredentialDetailSchema {
        .init(
            id: detail.id,
            userId: detail.userId,
            email: detail.email
        )
    }

    public func map(
        _ item: Credential.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema {
        .init(
            id: item.id,
            userId: item.userId,
            identityName: item.identityName,
            email: item.email
        )
    }
}
