import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {
    public func webMenuRemove(_ input: Operations.WebMenuRemove.Input)
        async throws -> Operations.WebMenuRemove.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenu()
        let deletedIds = try await useCase.execute(
            subject: subject,
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

    public func webMenuItemRemove(
        _ input: Operations.WebMenuItemRemove.Input
    ) async throws -> Operations.WebMenuItemRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenuItem()
        let deletedIds = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids, menuId: input.path.webMenuId)
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

    public func webPageRemove(_ input: Operations.WebPageRemove.Input)
        async throws -> Operations.WebPageRemove.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePage()
        let deletedIds = try await useCase.execute(
            subject: subject,
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
