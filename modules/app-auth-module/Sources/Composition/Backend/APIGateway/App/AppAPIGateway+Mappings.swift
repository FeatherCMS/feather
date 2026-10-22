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
            .AuthEmailQuerySchemasItemSearchRequestQuerySchema
    ) -> Email.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Email.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .identityId: field = .identityId
                    case .email: field = .email
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            identityId: query.filters.identityId
        )
    }

    public func responseQuery(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthEmailQuerySchemasItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthEmailQuerySchemasItemSearchResponseQuerySchema
    {
        let page = map(query.page).normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    AuthAdminAPI.Components.Schemas
                        .AuthEmailQuerySchemasItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .identityId: field = .identityId
                case .email: field = .email
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthEmailQuerySchemasItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                identityId: query.filters.identityId
            )
        )
    }

    public func mapQuery(
        _ item: Email.Search.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthEmailQuerySchemasItem {
        .init(id: item.id, identityId: item.identityId, email: item.email)
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthRolePermissionQueryItemSearchRequestQuerySchema
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
            .AuthRolePermissionQueryItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthRolePermissionQueryItemSearchResponseQuerySchema
    {
        let page = map(query.page).normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    AuthAdminAPI.Components.Schemas
                        .AuthRolePermissionQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .roleId: field = .roleId
                case .permissionId: field = .permissionId
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthRolePermissionQueryItemSearchResponseQuerySchema
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

    public func mapQuery(
        _ item: RolePermission.Search.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthRolePermissionQueryItemSchema {
        .init(roleId: item.roleId, permissionId: item.permissionId)
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthMagicLinkQueryItemSearchRequestQuerySchema
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
            .AuthMagicLinkQueryItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthMagicLinkQueryItemSearchResponseQuerySchema
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
                        .AuthMagicLinkQueryItemSearchResponseQuerySchema
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
                    .AuthMagicLinkQueryItemSearchResponseQuerySchema
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

    public func mapQuery(
        _ item: MagicLink.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthMagicLinkQueryItemSchema {
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
            .AuthCredentialQueryItemSearchRequestQuerySchema
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
            .AuthCredentialQueryItemSearchRequestQuerySchema
    )
        -> AuthAdminAPI.Components.Schemas
        .AuthCredentialQueryItemSearchResponseQuerySchema
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
                        .AuthCredentialQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .userId: field = .userId
                case .email: field = .email
                }
                return AuthAdminAPI.Components.Schemas
                    .AuthCredentialQueryItemSearchResponseQuerySchema
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

    public func mapQuery(
        _ item: Credential.List.Output.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthCredentialQueryItemSchema {
        .init(
            id: item.id,
            userId: item.userId,
            identityName: item.identityName,
            email: item.email
        )
    }
}
