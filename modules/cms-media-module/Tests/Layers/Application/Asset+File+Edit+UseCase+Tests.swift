import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import MediaDomain
import MediaModule
import Testing

import struct Foundation.Date

@testable import MediaApplication

@Suite
struct AssetFileEditUseCaseTests {
    @Test
    func clearsSelectedNullableFieldAndPreservesUnselectedField() async throws {
        let repository = Asset.File.Repository.Mock(asset: makeAsset())
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Asset.File.Edit.Scope(assets: repository)
        )
        let useCase = Asset.File.Edit.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction,
            objectKeyGenerator: TestObjectKeyGenerator()
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(
                id: "asset-1",
                title: .clear,
                altText: .unchanged
            )
        )

        #expect(result.title == nil)
        #expect(result.altText == "Existing alt text")
        #expect(await repository.updatedAsset?.title == nil)
        #expect(await repository.updatedAsset?.altText == "Existing alt text")
        #expect(await repository.updateCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }
}

private func makeAsset() -> Asset.File.Model {
    .init(
        id: "asset-1",
        folderId: nil,
        name: "cover.png",
        slug: "cover",
        slugPath: "cover",
        storageObjectId: "object-1",
        extension: "png",
        contentType: "image/png",
        sizeBytes: 128,
        status: .ready,
        title: "Existing title",
        altText: "Existing alt text",
        createdAt: Date(timeIntervalSince1970: 0),
        updatedAt: Date(timeIntervalSince1970: 0),
        deletedAt: nil
    )
}
