import FeatherApplication
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import FeatherStorage
import Foundation
import MediaApplication
public import MediaDomain
import MediaInfrastructure
public import MediaModule
import NIOCore

extension UseCases {
    public func enqueueVariantGeneration(
        assetId: String,
        processors: [Variant.Processor.Model]
    ) async throws {
        guard !processors.isEmpty else { return }
        try await jobs.enqueue(assetId: assetId)
    }
    public func activeVariantProcessors() async throws
        -> [Variant.Processor.Model]
    {
        try await databaseContext.database.withConnection { connection in
            let repo = Variant.Processor.Repository.Database(
                context: .init(
                    platform: databaseContext.platform,
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
            )
            return try await repo.listActive()
        }
    }
}
