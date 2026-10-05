public import FeatherApplication
public import FeatherContracts
public import FeatherStorage
public import Foundation
import MediaContracts
import MediaDomain
import MIME
import NIOCore

public struct CreateMediaAsset: UseCase {
    public enum Error: Swift.Error, Sendable {
        case duplicatePath
    }

    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let storageContext: StorageClientContext

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        storageContext: StorageClientContext
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.storageContext = storageContext
    }

    public struct Input: DTO {
        public let folderId: String?
        public let fileName: String
        public let `extension`: String
        public let title: String?
        public let altText: String?
        public let content: StorageSequence
        public let contentLength: Int64

        public init(
            folderId: String? = nil,
            fileName: String,
            `extension`: String,
            title: String? = nil,
            altText: String? = nil,
            content: StorageSequence,
            contentLength: Int64
        ) {
            self.folderId = folderId
            self.fileName = fileName
            self.extension = `extension`
            self.title = title
            self.altText = altText
            self.content = content
            self.contentLength = contentLength
        }

        public init(
            folderId: String? = nil,
            fileName: String,
            `extension`: String,
            title: String? = nil,
            altText: String? = nil,
            data: Data
        ) {
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            self.init(
                folderId: folderId,
                fileName: fileName,
                extension: `extension`,
                title: title,
                altText: altText,
                content: .init(buffer: buffer),
                contentLength: Int64(data.count)
            )
        }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaAssetDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await execute(input: input)
    }

    public func execute(input: Input) async throws -> MediaAssetDetail {
        let storageIdentity = try await transaction.run { scope in
            scope.assets.prepareStorageIdentity()
        }
        let file = normalizedFile(input.fileName, extension: input.extension)
        let slugPath = try await transaction.run { scope in
            let parent: MediaAssetNodeFolder?
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
                throw Error.duplicatePath
            }
            return slugPath
        }
        let storageObjectKey = try MediaAssetStorageObject.storageKey(
            assetID: storageIdentity.nodeId,
            key: "original",
            extension: file.extension,
            objectKeyGenerator: storageContext.objectKeyGenerator
        )
        let mediaType =
            MediaTypeDetector()
            .getPossibleMediaTypeForExtension(file.extension)?.rawValue
            ?? MediaType.Application.octetStream().rawValue
        try await storageContext.storage.upload(
            key: storageObjectKey,
            sequence: input.content,
            contentType: mediaType
        )

        do {
            let asset = try await transaction.run { scope in
                let parent: MediaAssetNodeFolder?
                if let folderId = input.folderId {
                    parent = try await scope.folders.find(id: folderId)
                }
                else {
                    parent = nil
                }
                let originalStorageObject = try await scope.storageObjects
                    .insert(
                        MediaAssetStorageObject.create(
                            key: "original",
                            extension: file.extension,
                            contentType: mediaType,
                            sizeInBytes: input.contentLength
                        )
                    )
                let asset = try await scope.assets.insert(
                    MediaAssetNodeFile.create(
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
            return try asset.asDetail(
                objectKeyGenerator: storageContext.objectKeyGenerator
            )
        }
        catch {
            try? await storageContext.storage.delete(key: storageObjectKey)
            throw error
        }
    }
}

extension CreateMediaAsset {
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
            MediaExtensionMatcher.canonicalExtension(from: `extension`) ?? "bin"
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
        folders: any MediaAssetNodeFolderRepository,
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
