import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webMenuItemSearch(
        _ input: Operations.WebMenuItemSearch.Input
    ) async throws -> Operations.WebMenuItemSearch.Output {
        let query: Components.Schemas.WebMenuItemListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.web.makeListMenuItems()
        let objectQuery = map(query)
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
                        data: .init(items: list.items.map(map), total: total)
                    )
                )
            )
        )
    }
}
