import FeatherModuleKit
public import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRoleQuery(
        _ input: Operations.UserRoleQuery.Input
    ) async throws -> Operations.UserRoleQuery.Output {
        let query: Components.Schemas.UserRoleListItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchRoles()
        let objectQuery = map(query)

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: mapResponse(query),
                        data: .init(
                            items: result.items.map(map),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

private func mapResponse(
    _ query: Components.Schemas.UserRoleListItemSearchRequestQuerySchema
) -> Components.Schemas.UserRoleListItemSearchResponseQuerySchema {
    .init(
        page: .init(
            size: query.page?.size ?? 20,
            number: query.page?.number ?? 1
        ),
        sort: query.sort?
            .map {
                .init(
                    field: .init(rawValue: $0.field.rawValue)!,
                    direction: $0.direction
                )
            },
        filters: .init(search: query.filters.search)
    )
}
