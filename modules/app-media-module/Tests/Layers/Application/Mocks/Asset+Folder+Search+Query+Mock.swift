import MediaModule

@testable import MediaApplication

extension Asset.Folder.Search.Query {
    actor Mock: Interface {
        private(set) var lastQuery: Asset.Folder.Search.Input.Query?
        private(set) var searchCallCount = 0

        func search(
            query: Asset.Folder.Search.Input.Query
        ) async throws -> Asset.Folder.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return .init(
                items: [
                    .init(
                        id: "folder-1",
                        parentId: query.parentId,
                        name: "Images",
                        slug: "images",
                        slugPath: "images",
                        assetCount: 3,
                        totalSizeBytes: 0,
                        createdAt: .init(timeIntervalSince1970: 0),
                        updatedAt: .init(timeIntervalSince1970: 0)
                    ),
                ],
                total: 7
            )
        }
    }
}
