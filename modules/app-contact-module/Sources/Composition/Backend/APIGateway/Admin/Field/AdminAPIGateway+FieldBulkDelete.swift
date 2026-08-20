import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFieldBulkDelete(
        _ input: Operations.ContactFieldBulkDelete.Input
    ) async throws -> Operations.ContactFieldBulkDelete.Output {
        let useCase = self.useCases.makeDeleteFormField()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        var deleted = 0
        var notFound = 0
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                await body.ids.asyncMap { id in
                    do {
                        try await useCase.execute(
                            subject: try await CurrentSubject.require(),
                            input: .init(id: id, formId: nil)
                        )
                        deleted += 1
                        return .init(id: id, status: .deleted)
                    }
                    catch {
                        notFound += 1
                        return .init(id: id, status: .notFound)
                    }
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: body.ids.count,
                            deleted: deleted,
                            notFound: notFound,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
