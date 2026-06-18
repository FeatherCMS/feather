import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userRoleSearch(
        _ input: Operations.UserRoleSearch.Input
    ) async throws -> Operations.UserRoleSearch.Output {
        let query: Components.Schemas.UserRoleListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeListRoles()
        let objectQuery = map(query)

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(
                            items: list.items.map(map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
