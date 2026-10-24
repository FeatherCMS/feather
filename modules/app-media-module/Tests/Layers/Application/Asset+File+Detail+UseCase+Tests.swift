import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import Foundation
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct AssetFileDetailUseCaseTests {
    @Test
    func returnsAssetWhenAuthorized() async throws {
        let query = Asset.File.Detail.Query.Mock(result: makeAssetDetail())
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Asset.File.Detail.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Asset.File.Detail.UseCase(
            authorizer: authorizer,
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(id: "asset-1")
        )

        #expect(result.id == "asset-1")
        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 1)
        #expect(await query.findCallCount == 1)
    }

    @Test
    func doesNotQueryWhenForbidden() async throws {
        let query = Asset.File.Detail.Query.Mock(result: makeAssetDetail())
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Asset.File.Detail.Scope(query: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Asset.File.Detail.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: .init(id: "asset-1")
            )
        }

        #expect(await executor.runCallCount == 0)
        #expect(await query.findCallCount == 0)
    }
}

private func makeAssetDetail() -> Asset.File.Detail.Output {
    .init(
        id: "asset-1",
        folderId: nil,
        name: "asset",
        slug: "asset",
        slugPath: "asset",
        url: "/asset.png",
        extension: "png",
        contentType: "image/png",
        sizeBytes: 1,
        status: "ready",
        title: nil,
        altText: nil,
        createdAt: .init(timeIntervalSince1970: 0),
        updatedAt: .init(timeIntervalSince1970: 0)
    )
}

extension Asset.File.Detail.Query {
    actor Mock: Interface {
        private(set) var findCallCount = 0
        private let result: Asset.File.Detail.Output

        init(result: Asset.File.Detail.Output) {
            self.result = result
        }

        func find(id: String) async throws -> Asset.File.Detail.Output {
            findCallCount += 1
            return result
        }
    }
}
