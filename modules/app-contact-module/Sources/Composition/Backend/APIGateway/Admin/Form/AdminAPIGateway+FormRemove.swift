public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {
    public func contactFormRemove(
        _ input: Operations.ContactFormRemove.Input
    ) async throws -> Operations.ContactFormRemove.Output {
        let useCase = self.useCases.makeRemoveContactForm()
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let deletedKeys = try await useCase.execute(
            subject: try await CurrentSubject.require(),
            input: .init(keys: body.ids)
        )
        let results = body.ids.map {
            Components.Schemas.DeleteResultListSchemaPayload(
                id: $0,
                status: deletedKeys.contains($0) ? .deleted : .notFound
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
                                deleted: deletedKeys.count,
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
