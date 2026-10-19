import FeatherApplication
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemPermissionQuery(
        _ input: Operations.SystemPermissionQuery.Input
    ) async throws -> Operations.SystemPermissionQuery.Output {
        let query: Components.Schemas.SystemPermissionQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }
        let normalizedQuery = normalizedPermissionQuery(from: query)

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeSearchPermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: permissionSearchQuery(from: normalizedQuery))
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responsePermissionQuery(from: normalizedQuery),
                        data: .init(
                            items: result.items.map(
                                permissionQueryItemSchema(from:)
                            ),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func normalizedPermissionQuery(
        from query: Components.Schemas
            .SystemPermissionQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.SystemPermissionQueryItemSearchRequestQuerySchema {
        let page = searchPage(from: query)

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: query.sort,
            filters: query.filters
        )
    }

    private func responsePermissionQuery(
        from query: Components.Schemas
            .SystemPermissionQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.SystemPermissionQueryItemSearchResponseQuerySchema {
        let page = searchPage(from: query)
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .SystemPermissionQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .notes:
                    field = .notes
                }
                return Components.Schemas
                    .SystemPermissionQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search, ids: query.filters.ids)
        )
    }

    private func searchPage(
        from query: Components.Schemas
            .SystemPermissionQueryItemSearchRequestQuerySchema
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func permissionSearchQuery(
        from query: Components.Schemas
            .SystemPermissionQueryItemSearchRequestQuerySchema
    ) -> SystemModule.Permission.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: SystemModule.Permission.Search.Input.Query.Sort.Field
                switch rule.field {
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .notes:
                    field = .notes
                }
                return SystemModule.Permission.Search.Input.Query.Sort(
                    field: field,
                    direction: searchSortDirection(from: rule.direction)
                )
            }

        return .init(
            page: searchPage(from: query),
            sort: sort,
            search: query.filters.search,
            ids: query.filters.ids
        )
    }

    private func searchSortDirection(
        from direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    private func permissionQueryItemSchema(
        from item: SystemModule.Permission.Search.Output.Item
    ) -> Components.Schemas.SystemPermissionQueryItemSchema {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            notes: item.notes
        )
    }
}
