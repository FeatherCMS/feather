import Application
import MediaApplication
import AdminOpenAPI

extension AdminAPI {
    func mediaFolderSearch(
        _ input: Operations.MediaFolderSearch.Input
    ) async throws -> Operations.MediaFolderSearch.Output {
        let query: Components.Schemas.MediaFolderListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await modules.media.makeListFolders()
            .execute(
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
                            total: result.items.count
                        )
                    )
                )
            )
        )
    }
}
