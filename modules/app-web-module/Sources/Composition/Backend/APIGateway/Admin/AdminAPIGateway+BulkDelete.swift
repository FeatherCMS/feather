import FeatherApplication
import FeatherBackend
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {
    public func webMenuBulkDelete(_ input: Operations.WebMenuBulkDelete.Input)
        async throws -> Operations.WebMenuBulkDelete.Output
    {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenu()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func webMenuItemBulkDelete(
        _ input: Operations.WebMenuItemBulkDelete.Input
    ) async throws -> Operations.WebMenuItemBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveMenuItem()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id, menuId: input.path.webMenuId)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }

    public func webPageBulkDelete(_ input: Operations.WebPageBulkDelete.Input)
        async throws -> Operations.WebPageBulkDelete.Output
    {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePage()
        let results:
            [Components.Schemas.BulkDeleteResponseSchema.ResultsPayloadPayload] =
                try await body.ids.asyncMap { id in
                    let deleted = try await useCase.execute(
                        subject: subject,
                        input: .init(id: id)
                    )
                    return Components.Schemas.BulkDeleteResponseSchema
                        .ResultsPayloadPayload(
                            id: id,
                            status: deleted ? .deleted : .notFound
                        )
                }
        return .ok(
            .init(
                body: .json(
                    .init(
                        results: results,
                        summary: .init(
                            requested: results.count,
                            deleted: results.filter { $0.status == .deleted }
                                .count,
                            notFound: results.filter { $0.status == .notFound }
                                .count,
                            forbidden: 0
                        )
                    )
                )
            )
        )
    }
}
