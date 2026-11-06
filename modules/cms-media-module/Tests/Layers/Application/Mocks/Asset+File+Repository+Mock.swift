import FeatherDomain
import MediaDomain
import MediaModule

@testable import MediaApplication

extension Asset.File.Repository {
    actor Mock: Interface {
        private let asset: Asset.File.Model
        private(set) var updatedAsset: Asset.File.Model?
        private(set) var updateCallCount = 0

        enum MockError: Swift.Error {
            case unexpectedCall
        }

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
