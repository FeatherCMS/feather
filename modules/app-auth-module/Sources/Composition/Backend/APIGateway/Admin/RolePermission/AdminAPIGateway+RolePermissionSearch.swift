import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func authRolePermissionSearch(
        _ input: Operations.AuthRolePermissionSearch.Input
    ) async throws -> Operations.AuthRolePermissionSearch.Output {
        let query:
            Components.Schemas.AuthRolePermissionListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeListRolePermissions()
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
