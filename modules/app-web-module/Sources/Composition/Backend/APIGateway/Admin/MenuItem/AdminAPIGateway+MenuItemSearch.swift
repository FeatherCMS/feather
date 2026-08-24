import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuItemSearch(
        _ input: Operations.WebMenuItemSearch.Input
    ) async throws -> Operations.WebMenuItemSearch.Output {
        let query: Components.Schemas.WebMenuItemListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeListMenuItems()
        let objectQuery = useCases.map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(menuId: input.path.webMenuId, query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(menuId: input.path.webMenuId, query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(
                            items: list.items.map(useCases.map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
