import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
public import FeatherModuleKit
import FeatherStorage
import Foundation
public import MediaApplication
public import MediaDomain
import MediaInfrastructure
public import MediaModule
import NIOCore

extension UseCases {
    public func addAssetAndEnqueue(
        subject: Subject,
        input: Asset.File.Add.Input
    ) async throws -> Asset.File.Add.Output {
        let result = try await makeAddAsset()
            .execute(subject: subject, input: input)
        let processors = try await activeVariantProcessors()
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }
    public func addAssetAndEnqueue(input: Asset.File.Add.Input)
        async throws -> Asset.File.Add.Output
    {
        let result = try await makeAddAsset().execute(input: input)
        let processors = try await activeVariantProcessors()
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }
    public func addAssetAndEnqueue(
        input: Asset.File.Add.Input,
        processors: [Variant.Processor.Model]
    ) async throws -> Asset.File.Add.Output {
        let result = try await makeAddAsset().execute(input: input)
        return try await finalizeAssetCreation(
            result: result,
            input: input,
            processors: processors
        )
    }
    private func finalizeAssetCreation(
        result: Asset.File.Add.Output,
        input: Asset.File.Add.Input,
        processors: [Variant.Processor.Model]
    ) async throws -> Asset.File.Add.Output {
        let matchingProcessors = processors.filter {
            Asset.ExtensionMatcher.matches(
                extension: input.extension,
                processor: $0
            )
        }
        let updated = try await databaseContext.database.withConnection {
            connection in
            let repo = Asset.File.Repository.Database(
                context: .init(
                    platform: databaseContext.platform,
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
            )
            guard let asset = try await repo.find(id: result.detail.id) else {
                return result
            }
            var value = asset
            value.status = matchingProcessors.isEmpty ? .ready : .processing
            let updatedAsset = try await repo.update(value)
            return .init(
                detail: .init(
                    id: updatedAsset.id,
                    folderId: updatedAsset.folderId,
                    name: updatedAsset.name,
                    slug: updatedAsset.slug,
                    slugPath: updatedAsset.slugPath,
                    url: try mediaAssetPublicURL(
                        id: updatedAsset.id,
                        slugPath: updatedAsset.slugPath,
                        filename: updatedAsset.name,
                        extension: updatedAsset.extension,
                        objectKeyGenerator: storageContext.objectKeyGenerator
                    ),
                    extension: updatedAsset.extension,
                    contentType: updatedAsset.contentType,
                    sizeBytes: updatedAsset.sizeBytes,
                    status: updatedAsset.status.rawValue,
                    title: updatedAsset.title,
                    altText: updatedAsset.altText,
                    createdAt: updatedAsset.createdAt,
                    updatedAt: updatedAsset.updatedAt
                )
            )
        }
        if !matchingProcessors.isEmpty {
            try await enqueueVariantGeneration(
                assetId: result.detail.id,
                processors: matchingProcessors
            )
        }
        return updated
    }
}
