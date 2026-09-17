import FeatherApplication
import FeatherBackend
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetNodeRemove(
        _ input: Operations.MediaAssetNodeRemove.Input
    ) async throws -> Operations.MediaAssetNodeRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let deletedIds = try await useCases.deleteAssetNodesAndFiles(
            subject: subject,
            assetIds: body.ids
        )
        let results = body.ids.map {
            Components.Schemas.DeleteResultListSchemaPayload(
                id: $0,
                status: deletedIds.contains($0) ? .deleted : .notFound
            )
        }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: body.results ? results : nil,
                        summary: body.summary
                            ? .init(
                                requested: results.count,
                                deleted:
                                    results.filter { $0.status == .deleted }
                                    .count,
                                omitted:
                                    results.filter { $0.status != .deleted }
                                    .count
                            ) : nil
                    )
                )
            )
        )
    }

}
