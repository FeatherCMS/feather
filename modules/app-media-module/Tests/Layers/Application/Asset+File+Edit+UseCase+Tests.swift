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

private struct TestObjectKeyGenerator: ObjectKeyGenerator {
    func generate(from value: String) throws -> String { value }
}

extension Asset.File.Repository {
    actor Mock: Interface {
        private let asset: Asset.File.Model
        private(set) var updatedAsset: Asset.File.Model?
        private(set) var updateCallCount = 0

        init(asset: Asset.File.Model) {
            self.asset = asset
        }

        nonisolated func prepareStorageIdentity()
            -> Asset.File.StorageIdentity
        {
            .init(nodeId: "asset-1")
        }

        func insert(
            _ model: Asset.File.Model.New,
            storageIdentity: Asset.File.StorageIdentity
        ) async throws -> Asset.File.Model {
            throw MockError.unexpectedCall
        }

        func update(_ model: Asset.File.Model) async throws
            -> Asset.File.Model
        {
            updateCallCount += 1
            updatedAsset = model
            return model
        }

        func updateStatus(id: String, status: Asset.File.Model.Status)
            async throws
        {
            throw MockError.unexpectedCall
        }

        func find(id: String) async throws -> Asset.File.Model? {
            id == asset.id ? asset : nil
        }

        func find(slugPath: String) async throws -> Asset.File.Model? {
            throw MockError.unexpectedCall
        }

        func list(folderIds: [String]) async throws -> [Asset.File.Model] {
            throw MockError.unexpectedCall
        }

        func delete(ids: [String]) async throws -> [String] {
            throw MockError.unexpectedCall
        }
    }
    }

    private enum MockError: Error {
    case unexpectedCall
}
