public import FeatherApplication
public import FeatherModuleKit
import FeatherStorage
import MediaDomain
public import MediaModule

extension Asset.File.Remove {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>
        let storageContext: StorageClientContext

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>,
            storageContext: StorageClientContext
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.storageContext = storageContext
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let snapshot = try await transaction.run { scope in
                var assets: [String: Asset.File.Model] = [:]
                var folders: [String: Asset.Folder.Model] = [:]
                for id in input.ids {
                    if let asset = try await scope.assets.find(id: id) {
                        assets[asset.id] = asset
                    }
                    if let folder = try await scope.folders.find(id: id) {
                        for descendant in try await scope.folders
                            .listDescendants(
                                slugPath: folder.slugPath
                            )
                        { folders[descendant.id] = descendant }
                    }
                }
                for asset in try await scope.assets.list(
                    folderIds: Array(folders.keys)
                ) { assets[asset.id] = asset }
                var storageObjects: [Snapshot.StoredObject] = []
                for asset in assets.values {
                    storageObjects.append(
                        contentsOf: try await scope.storageObjects
                            .list(
                                assetNodeFileIds: [asset.id]
                            )
                            .map { .init(assetId: asset.id, object: $0) }
                    )
                }
                return Snapshot(
                    assets: Array(assets.values),
                    folders: Array(folders.values),
                    storageObjects: storageObjects
                )
            }
            for storageObject in snapshot.storageObjects {
                try? await storageContext.storage.delete(
                    key: try StorageObject.Model.storageKey(
                        assetID: storageObject.assetId,
                        key: storageObject.object.key,
                        extension: storageObject.object.extension,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    )
                )
            }
            _ = try await transaction.run { scope in
                for asset in snapshot.assets {
                    try await adjustFolderAggregates(
                        folders: scope.folders,
                        folderId: asset.folderId,
                        sizeDelta: -asset.sizeBytes,
                        assetCountDelta: -1
                    )
                }
                _ = try await scope.assets.delete(
                    ids: snapshot.assets.map(\.id)
                )
                _ = try await scope.folders.delete(
                    ids: snapshot.folders.map(\.id)
                )
            }
            return .init()
        }
    }
}

extension UseCase {
    fileprivate func adjustFolderAggregates(
        folders: any Asset.Folder.Repository.Interface,
        folderId: String?,
        sizeDelta: Int64,
        assetCountDelta: Int
    ) async throws {
        guard let folderId else { return }
        var current = try await folders.find(id: folderId)
        while let folder = current {
            var updated = folder
            updated.updateAggregates(
                assetCountDelta: assetCountDelta,
                totalSizeBytesDelta: sizeDelta
            )
            _ = try await folders.update(updated)
            if let parentId = folder.parentId {
                current = try await folders.find(id: parentId)
            }
            else {
                current = nil
            }
        }
    }
}
