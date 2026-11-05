public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func authRolePermissionQuery(
        _ input: Operations.AuthRolePermissionQuery.Input
    ) async throws -> Operations.AuthRolePermissionQuery.Output {
        let query:
            Components.Schemas
                .AuthRolePermissionQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeSearchRolePermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: mapRolePermissionSearchQuery(query))
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: mapRolePermissionSearchQuery(query))
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: rolePermissionSearchResponseQuery(query),
                        data: .init(
                            items: result.items.map(
                                mapRolePermissionSearchItem
                            ),
                            total: total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapRolePermissionSearchQuery(
        _ query: Components.Schemas
            .AuthRolePermissionQueryItemSearchRequestQuerySchema
    ) -> RolePermission.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: RolePermission.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .roleId: field = .roleId
                    case .permissionId: field = .permissionId
                    }
                    return .init(
                        field: field,
                        direction: mapRolePermissionSortDirection(
                            rule.direction
                        )
                    )
                },
            search: query.filters.search
        )
    }

    private func rolePermissionSearchResponseQuery(
        _ query: Components.Schemas
            .AuthRolePermissionQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.AuthRolePermissionQueryItemSearchResponseQuerySchema
    {
        let page = mapRolePermissionSearchQuery(query).page.normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .AuthRolePermissionQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .roleId: field = .roleId
                case .permissionId: field = .permissionId
                }
                return Components.Schemas
                    .AuthRolePermissionQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: field,
                        direction: rule.direction
                    )
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    private func mapRolePermissionSearchItem(
        _ item: RolePermission.Search.Output.Item
    ) -> Components.Schemas.AuthRolePermissionQueryItemSchema {
        .init(roleId: item.roleId, permissionId: item.permissionId)
    }

    private func mapRolePermissionSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
