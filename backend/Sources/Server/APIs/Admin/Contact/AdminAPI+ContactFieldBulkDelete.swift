import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFieldBulkDelete(
        _ input: Operations.ContactFieldBulkDelete.Input
    ) async throws -> Operations.ContactFieldBulkDelete.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.delete
        )
        let useCase = modules.contact.makeDeleteContactFormItem()
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case let .json(value): body = value
        }
        var deleted = 0
        var notFound = 0
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    do {
                        try await useCase.execute(.init(id: id, formId: nil))
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
