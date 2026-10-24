import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderQuery(
        _ input: Operations.MediaFolderQuery.Input
    ) async throws -> Operations.MediaFolderQuery.Output {
        let query:
            Components.Schemas.MediaFolderQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeSearchFolders()
            .execute(
                subject: subject,
                input: .init(query: map(query))
            )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(from: query),
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
