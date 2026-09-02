import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {

    public func accountInvitationBulkDelete(
        _ input: Operations.AccountInvitationBulkDelete.Input
    ) async throws -> Operations.AccountInvitationBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveInvitation()

        let deletedIds = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload(
                id: $0,
                status: deletedIds.contains($0) ? .deleted : .notFound
            )
        }

        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deletedIds.count,
                            notFound: body.ids.count - deletedIds.count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
