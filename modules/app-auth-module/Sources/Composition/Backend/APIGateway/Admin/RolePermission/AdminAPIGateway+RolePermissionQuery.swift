public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

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
                        query: responseQuery(query),
                        data: .init(
                            items: result.items.map(mapQuery),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
