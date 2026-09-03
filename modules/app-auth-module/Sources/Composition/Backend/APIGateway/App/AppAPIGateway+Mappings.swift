import AuthAdminAPI
import AuthApplication
import AuthDomain
import FeatherApplication
import FeatherContracts
import Foundation
import UserApplication

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
        _ page: AuthAdminAPI.Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    public func map(
        _ item: SessionList.Item
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
            .AuthRolePermissionListItemSearchQuerySchema
    ) -> RolePermissionList.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: RolePermissionList.Query.Sort.Field
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

    public func map(
        _ detail: RolePermissionDetail
    ) -> AuthAdminAPI.Components.Schemas.AuthRolePermissionDetailSchema {
        .init(roleId: detail.roleId, permissionId: detail.permissionId)
    }

    public func map(
        _ item: RolePermissionList.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthRolePermissionListItemSchema {
        .init(roleId: item.roleId, permissionId: item.permissionId)
    }

    public func map(
        _ query: AuthAdminAPI.Components.Schemas
            .AuthMagicLinkListItemSearchQuerySchema
    ) -> MagicLinkList.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: MagicLinkList.Query.Sort.Field
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

    public func map(
        _ detail: MagicLinkDetail
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
        _ item: MagicLinkList.Item
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
            .AuthCredentialListItemSearchQuerySchema
    ) -> CredentialList.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: CredentialList.Query.Sort.Field
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

    public func map(
        _ detail: CredentialDetail
    ) -> AuthAdminAPI.Components.Schemas.AuthCredentialDetailSchema {
        .init(
            id: detail.id,
            userId: detail.userId,
            email: detail.email
        )
    }

    public func map(
        _ item: CredentialList.Item
    ) -> AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema {
        .init(
            id: item.id,
            userId: item.userId,
            identityName: item.identityName,
            email: item.email
        )
    }
}
