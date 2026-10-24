import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Foundation
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct AssetFolderSearchUseCaseTests {
    @Test
    func searchesFoldersWithTheRequestedQuery() async throws {
        let query = Asset.Folder.Search.Query.Mock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Asset.Folder.Search.Scope(query: query)
        )
        let useCase = Asset.Folder.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )
        let inputQuery = Asset.Folder.Search.Input.Query(
            page: .init(size: 5, number: 2),
            sort: [
                .init(field: .assetCount, direction: .desc),
            ],
            parentId: "parent-1"
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(query: inputQuery)
        )

        #expect(result.items.map(\.id) == ["folder-1"])
        #expect(result.total == 7)
        #expect(await query.lastQuery?.parentId == "parent-1")
        #expect(await query.lastQuery?.page.size == 5)
        #expect(await query.lastQuery?.page.number == 2)
        #expect(await query.lastQuery?.sort.first?.field == .assetCount)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func doesNotRunFolderSearchWhenForbidden() async {
        let query = Asset.Folder.Search.Query.Mock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Asset.Folder.Search.Scope(query: query)
        )
        let useCase = Asset.Folder.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: .init(query: .init())
            )
        }

        #expect(await query.searchCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }
}

extension Asset.Folder.Search.Query {
    actor Mock: Interface {
        private(set) var lastQuery: Asset.Folder.Search.Input.Query?
        private(set) var searchCallCount = 0

        func search(query: Asset.Folder.Search.Input.Query) async throws
            -> Asset.Folder.Search.Output
        {
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
