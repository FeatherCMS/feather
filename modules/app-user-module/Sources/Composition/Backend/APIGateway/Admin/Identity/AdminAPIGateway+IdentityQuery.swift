import FeatherModuleKit
public import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityQuery(
        _ input: Operations.UserIdentityQuery.Input
    ) async throws -> Operations.UserIdentityQuery.Output {
        let query:
            Components.Schemas.UserIdentityListItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchIdentities()
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
    _ query: Components.Schemas.UserIdentityListItemSearchRequestQuerySchema
) -> Components.Schemas.UserIdentityListItemSearchResponseQuerySchema {
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
        filters: .init(
            search: query.filters.search,
            role: query.filters.role
        )
    )
}
