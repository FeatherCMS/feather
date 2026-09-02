import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherBackend
import FeatherContracts

extension AdminAPIGateway {

    public func blogAuthorBulkDelete(
        _ input: Operations.BlogAuthorBulkDelete.Input
    ) async throws -> Operations.BlogAuthorBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveAuthor()
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

    public func blogAuthorLinkBulkDelete(
        _ input: Operations.BlogAuthorLinkBulkDelete.Input
    ) async throws -> Operations.BlogAuthorLinkBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveAuthorLink()
        let deletedIds = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids, authorId: input.path.blogAuthorId)
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

    public func blogPostBulkDelete(
        _ input: Operations.BlogPostBulkDelete.Input
    ) async throws -> Operations.BlogPostBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePost()
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

    public func blogTagBulkDelete(
        _ input: Operations.BlogTagBulkDelete.Input
    ) async throws -> Operations.BlogTagBulkDelete.Output {
        let body: Components.Schemas.BulkDeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveTag()
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
