import AdminOpenAPI
import AuthApplication
import Application

extension AdminAPI {

    func userRolePermissionSearch(
        _ input: Operations.UserRolePermissionSearch.Input
    ) async throws -> Operations.UserRolePermissionSearch.Output {
        let query:
            Components.Schemas.UserRolePermissionListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeListRolePermissions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: map(query))
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: map(query))
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(
                            items: result.items.map(map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
