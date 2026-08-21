import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormBulkDelete(
        _ input: Operations.ContactFormBulkDelete.Input
    ) async throws -> Operations.ContactFormBulkDelete.Output {
        let useCase = self.useCases.makeDeleteContactForm()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        var deleted = 0
        var notFound = 0
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let didDelete = try await useCase.execute(
                        subject: try await CurrentSubject.require(),
                        input: .init(id: id)
                    )
                    if didDelete {
                        deleted += 1
                        return .init(id: id, status: .deleted)
                    }
                    notFound += 1
                    return .init(id: id, status: .notFound)
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
