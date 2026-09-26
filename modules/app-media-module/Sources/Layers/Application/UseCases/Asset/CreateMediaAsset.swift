public import FeatherApplication
public import FeatherContracts
public import FeatherStorage
public import Foundation
import NIOCore
import MediaContracts
import MediaDomain

public struct CreateMediaAsset: UseCase {
    public enum Error: Swift.Error, Sendable {
        case duplicatePath
    }

    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let storage: any StorageClient
    let storageKeyShard: MediaStorageKeyShard

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        storage: any StorageClient,
        storageKeyShard: MediaStorageKeyShard = .init()
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.storage = storage
        self.storageKeyShard = storageKeyShard
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
        let objectKey = MediaStorageObjectKey.original(
            assetID: storageIdentity.nodeId,
            fileExtension: file.extension
        )
        try await storage.upload(
            key: storageKeyShard.physicalKey(for: objectKey),
            sequence: input.content
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
                let storageObject = try await scope.storageObjects.insert(
                    MediaAssetStorageObject.create(objectKey: objectKey)
                )
                let asset = try await scope.assets.insert(
                    MediaAssetNodeFile.create(
                        folderId: parent?.id,
                        name: file.name,
                        slug: file.slug,
                        slugPath: slugPath,
                        extension: file.extension,
                        contentType: contentType(for: file.extension),
                        sizeBytes: input.contentLength,
                        title: input.title,
                        altText: input.altText
                    ),
                    storageIdentity: storageIdentity,
                    storageObjectId: storageObject.id
                )
                try await adjustFolderAggregates(
                    folders: scope.folders,
                    folderId: parent?.id,
                    sizeDelta: input.contentLength,
                    assetCountDelta: 1
                )
                return asset
            }
            return asset.asDetail
        }
        catch {
            _ = try? await MediaStorageData.delete(
                from: storage,
                key: storageKeyShard.physicalKey(for: objectKey)
            )
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

    fileprivate func contentType(for `extension`: String) -> String {
        switch `extension` {
        case "jpeg", "jpg": return "image/jpeg"
        case "png": return "image/png"
        case "gif": return "image/gif"
        case "webp": return "image/webp"
        case "pdf": return "application/pdf"
        case "mp4": return "video/mp4"
        default: return "application/octet-stream"
        }
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
