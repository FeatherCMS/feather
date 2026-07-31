import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormBulkDelete(
        _ input: Operations.ContactFormBulkDelete.Input
    ) async throws -> Operations.ContactFormBulkDelete.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Forms.delete
        )
        let useCase = modules.contact.makeDeleteContactForm()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case let .json(value): body = value
        }
        var deleted = 0
        var notFound = 0
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let didDelete = try await useCase.execute(.init(id: id))
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
