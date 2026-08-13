import FeatherApplication
import FeatherBackend
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMetadataBulkDelete(
        _ input: Operations.WebMetadataBulkDelete.Input
    ) async throws -> Operations.WebMetadataBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeRemoveMetadata()
        let subject = try await CurrentSubject.require()

        var deletedCount = 0
        var notFoundCount = 0

        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    if deleted {
                        deletedCount += 1
                        return .init(id: id, status: .deleted)
                    }
                    notFoundCount += 1
                    return .init(id: id, status: .notFound)
                }

        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deletedCount,
                            notFound: notFoundCount,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
