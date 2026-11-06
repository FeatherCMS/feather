import FeatherApplication
import FeatherModuleKit
import FeatherTesting
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
                .init(field: .assetCount, direction: .desc)
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
