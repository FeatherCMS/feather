import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormSubmissionDelete(
        _ input: Operations.ContactFormSubmissionDelete.Input
    ) async throws -> Operations.ContactFormSubmissionDelete.Output {
        let useCase = self.useCases.makeDeleteContactFormSubmission()
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let deletedIds = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(ids: body.ids)
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
                                requested: body.ids.count,
                                deleted: deletedIds.count,
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
