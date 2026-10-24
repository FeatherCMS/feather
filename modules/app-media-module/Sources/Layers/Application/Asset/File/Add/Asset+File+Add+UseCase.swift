public import FeatherApplication
public import FeatherModuleKit
import FeatherStorage
import Foundation
import MIME
import MediaDomain
public import MediaModule
import NIOCore

extension Asset.File.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Asset.File.Add.Scope>
        let storageContext: StorageClientContext

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Asset.File.Add.Scope>,
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
            return try await execute(input: input)
        }

        public func execute(input: Input) async throws -> Output {
            let storageIdentity = try await transaction.run { scope in
                scope.assets.prepareStorageIdentity()
            }
            let file = normalizedFile(
                input.fileName,
                extension: input.extension
            )
            let slugPath = try await transaction.run { scope in
                let parent: Asset.Folder.Model?
                if let folderId = input.folderId {
                    parent = try await scope.folders.find(id: folderId)
                }
                else {
                    parent = nil
                }
                let slugPath =
                    parent.map { "\($0.slugPath)/\(file.slug)" } ?? file.slug
                let folderExists =
                    try await scope.folders.find(slugPath: slugPath) != nil
                let assetExists =
                    try await scope.assets.find(slugPath: slugPath) != nil
                if folderExists || assetExists {
                    throw Asset.File.Add.Error.duplicatePath
                }
                return slugPath
            }
            let storageObjectKey = try StorageObject.Model.storageKey(
                assetID: storageIdentity.nodeId,
                key: "original",
                extension: file.extension,
                objectKeyGenerator: storageContext.objectKeyGenerator
            )
            let mediaType =
                MediaTypeDetector()
                .getPossibleMediaTypeForExtension(file.extension)?
                .rawValue
                ?? MediaType.Application.octetStream().rawValue
            try await storageContext.storage.upload(
                key: storageObjectKey,
                sequence: input.content,
                contentType: mediaType
            )

            do {
                let asset = try await transaction.run { scope in
                    let parent: Asset.Folder.Model?
                    if let folderId = input.folderId {
                        parent = try await scope.folders.find(id: folderId)
                    }
                    else {
                        parent = nil
                    }
                    let originalStorageObject = try await scope.storageObjects
                        .insert(
                            StorageObject.Model.create(
                                key: "original",
                                extension: file.extension,
                                contentType: mediaType,
                                sizeInBytes: input.contentLength
                            )
                        )
                    let asset = try await scope.assets.insert(
                        Asset.File.Model.create(
                            folderId: parent?.id,
                            name: file.name,
                            slug: file.slug,
                            slugPath: slugPath,
                            storageObjectId: originalStorageObject.id,
                            extension: file.extension,
                            contentType: mediaType,
                            sizeBytes: input.contentLength,
                            title: input.title,
                            altText: input.altText
                        ),
                        storageIdentity: storageIdentity
                    )
                    try await adjustFolderAggregates(
                        folders: scope.folders,
                        folderId: parent?.id,
                        sizeDelta: input.contentLength,
                        assetCountDelta: 1
                    )
                    return asset
                }
                return .init(
                    id: asset.id,
                    folderId: asset.folderId,
                    name: asset.name,
                    slug: asset.slug,
                    slugPath: asset.slugPath,
                    url: try mediaAssetPublicURL(
                        id: asset.id,
                        slugPath: asset.slugPath,
                        filename: asset.name,
                        extension: asset.extension,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    ),
                    extension: asset.extension,
                    contentType: asset.contentType,
                    sizeBytes: asset.sizeBytes,
                    status: asset.status.rawValue,
                    title: asset.title,
                    altText: asset.altText,
                    createdAt: asset.createdAt,
                    updatedAt: asset.updatedAt
                )
            }
            catch {
                try? await storageContext.storage.delete(key: storageObjectKey)
                throw error
            }
        }
    }
}

extension Asset.File.Add.UseCase {
    fileprivate struct NormalizedFile {
        let name: String
        let slug: String
        let `extension`: String
    }

    fileprivate func normalizedFile(_ value: String, `extension`: String)
        -> NormalizedFile
    {
        let raw = value.split(separator: "/").last.map(String.init) ?? value
        let dot = raw.lastIndex(of: ".")
        let name =
            dot.map { String(raw[..<$0]) }.flatMap { $0.isEmpty ? nil : $0 }
            ?? raw
        let safeName =
            name.whitespaceTrimmed.isEmpty
            ? "asset" : name
        let slug = normalizedSlug(safeName)
        let ext =
            Asset.ExtensionMatcher.canonicalExtension(from: `extension`)
            ?? "bin"
        return .init(
            name: safeName,
            slug: slug.isEmpty ? "asset" : slug,
            extension: ext
        )
    }

    fileprivate func normalizedSlug(_ value: String) -> String {
        value.lowercased()
            .replacingOccurrences(
                of: "[^a-z0-9]+",
                with: "-",
                options: .regularExpression
            )
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

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
            updated.assetCount += assetCountDelta
            updated.totalSizeBytes += sizeDelta
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
