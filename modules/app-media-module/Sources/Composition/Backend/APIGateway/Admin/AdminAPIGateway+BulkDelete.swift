import FeatherApplication
import FeatherBackend
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetBulkDelete(
        _ input: Operations.MediaAssetBulkDelete.Input
    ) async throws -> Operations.MediaAssetBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCases.deleteAssetAndFiles(
                        subject: subject,
                        assetId: id
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func mediaFolderBulkDelete(
        _ input: Operations.MediaFolderBulkDelete.Input
    ) async throws -> Operations.MediaFolderBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteFolder()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func mediaProcessorBulkDelete(
        _ input: Operations.MediaProcessorBulkDelete.Input
    ) async throws -> Operations.MediaProcessorBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeDeleteProcessor()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
