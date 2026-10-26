public import FeatherApplication
public import FeatherModuleKit
import FeatherStorage
import Foundation
import MIME
public import MediaDomain
public import MediaModule
import NIOCore

extension Asset.File.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>
        let storageContext: StorageClientContext
        let jobs: any Asset.File.GenerateVariant.JobController.Interface

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>,
            storageContext: StorageClientContext,
            jobs: any Asset.File.GenerateVariant.JobController.Interface
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.storageContext = storageContext
            self.jobs = jobs
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
            try await execute(input: input, processorOverride: nil)
        }

        public func execute(
            input: Input,
            processors: [Variant.Processor.Model]
        ) async throws -> Output {
            try await execute(input: input, processorOverride: processors)
        }

        private func execute(
            input: Input,
            processorOverride: [Variant.Processor.Model]?
        ) async throws -> Output {
            let processors: [Variant.Processor.Model]
            if let processorOverride {
                processors = processorOverride
            }
            else {
                processors = try await transaction.run { scope in
                    try await scope.variantProcessors.listActive()
                }
            }
            let matchingProcessors = processors.filter {
                Asset.ExtensionMatcher.matches(
                    extension: input.extension,
                    processor: $0
                )
            }
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
                    throw Error.duplicatePath
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
                    let status: Asset.File.Model.Status =
                        matchingProcessors.isEmpty ? .ready : .processing
                    try await scope.assets.updateStatus(
                        id: asset.id,
                        status: status
                    )
                    return asset
                }
                let status: Asset.File.Model.Status =
                    matchingProcessors.isEmpty ? .ready : .processing
                if !matchingProcessors.isEmpty {
                    try await jobs.enqueue(assetId: asset.id)
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
                    status: status.rawValue,
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
        let slug = Asset.File.Model.slug(from: safeName)
        let ext =
            Asset.ExtensionMatcher.canonicalExtension(from: `extension`)
            ?? "bin"
        return .init(
            name: safeName,
            slug: slug.isEmpty ? "asset" : slug,
            extension: ext
        )
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
