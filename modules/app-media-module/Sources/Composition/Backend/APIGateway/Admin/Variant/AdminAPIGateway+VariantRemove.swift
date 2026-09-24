import FeatherContracts
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantRemove(_ input: Operations.MediaVariantRemove.Input)
        async throws -> Operations.MediaVariantRemove.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let deleted = try await useCases.makeRemoveVariant()
            .execute(subject: subject, input: .init(ids: body.ids))
        let results = body.ids.map {
            Components.Schemas.DeleteResultListSchemaPayload(
                id: $0,
                status: deleted.contains($0) ? .deleted : .notFound
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
