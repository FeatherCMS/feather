import AdminOpenAPI
import SystemApplication
import Application

extension AdminAPI {

    func systemVariableSearch(
        _ input: Operations.SystemVariableSearch.Input
    ) async throws -> Operations.SystemVariableSearch.Output {
        let query: Components.Schemas.SystemVariableListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.system.makeListVariables()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = list.items.map(map)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(items: items, total: total)
                    )
                )
            )
        )
    }
}
