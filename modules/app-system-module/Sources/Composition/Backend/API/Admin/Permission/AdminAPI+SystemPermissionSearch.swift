import FeatherApplication
import FeatherContracts
import SystemAdminAPI
import SystemApplication

extension SystemBackend {

    public func systemPermissionSearch(
        _ input: Operations.SystemPermissionSearch.Input
    ) async throws -> Operations.SystemPermissionSearch.Output {
        let query: Components.Schemas.SystemPermissionListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.makeListPermissions()
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
