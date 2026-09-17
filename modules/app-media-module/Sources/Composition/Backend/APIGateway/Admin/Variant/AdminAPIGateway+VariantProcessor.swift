import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantProcessorGet(_ input: Operations.MediaVariantProcessorGet.Input) async throws -> Operations.MediaVariantProcessorGet.Output {
        let subject = try await CurrentSubject.require()
        guard let result = try await useCases.makeGetVariantProcessor().execute(
            subject: subject,
            input: .init(
                variantId: input.path.mediaVariantId,
                id: input.path.mediaVariantProcessorId
            )
        ) else { return .notFound }
        return .ok(.init(body: .json(map(result))))
    }

    public func mediaVariantProcessorCreate(_ input: Operations.MediaVariantProcessorCreate.Input) async throws -> Operations.MediaVariantProcessorCreate.Output {
        let body: Components.Schemas.MediaVariantProcessorCreateSchema
        switch input.body { case .json(let value): body = value }
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeCreateVariantProcessor().execute(subject: subject, input: .init(processor: .init(variantId: input.path.mediaVariantId, name: body.name, matchExtensions: body.matchExtensions, commandTemplate: body.commandTemplate, isActive: body.isActive)))
            return .created(.init(body: .json(map(result))))
        }
        catch CreateMediaVariantProcessor.Error.variantNotFound {
            return .notFound
        }
    }

    public func mediaVariantProcessorUpdate(_ input: Operations.MediaVariantProcessorUpdate.Input) async throws -> Operations.MediaVariantProcessorUpdate.Output {
        let body: Components.Schemas.MediaVariantProcessorCreateSchema
        switch input.body { case .json(let value): body = value }
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeEditVariantProcessor().execute(subject: subject, input: .init(variantId: input.path.mediaVariantId, id: input.path.mediaVariantProcessorId, processor: .init(variantId: input.path.mediaVariantId, name: body.name, matchExtensions: body.matchExtensions, commandTemplate: body.commandTemplate, isActive: body.isActive)))
            return .ok(.init(body: .json(map(result))))
        }
        catch EditMediaVariantProcessor.Error.notFound {
            return .notFound
        }
    }

    public func mediaVariantProcessorList(_ input: Operations.MediaVariantProcessorList.Input) async throws -> Operations.MediaVariantProcessorList.Output {
        let query: Components.Schemas.MediaVariantProcessorListItemSearchQuerySchema
        switch input.body { case .json(let value): query = value }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchVariantProcessors()
        let objectQuery = map(query)
        do {
            let list = try await useCase.execute(subject: subject, input: .init(variantId: input.path.mediaVariantId, query: objectQuery))
            let total = try await useCase.count(subject: subject, input: .init(variantId: input.path.mediaVariantId, query: objectQuery))
            return .ok(.init(body: .json(.init(query: query, data: .init(items: list.items.map(map), total: total)))))
        }
        catch SearchMediaVariantProcessors.Error.variantNotFound {
            return .notFound
        }
    }

    public func mediaVariantProcessorRemove(_ input: Operations.MediaVariantProcessorRemove.Input) async throws -> Operations.MediaVariantProcessorRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body { case .json(let value): body = value }
        let subject = try await CurrentSubject.require()
        let deleted = try await useCases.makeRemoveVariantProcessor().execute(subject: subject, input: .init(variantId: input.path.mediaVariantId, ids: body.ids))
        let results = body.ids.map { Components.Schemas.DeleteResultListSchemaPayload(id: $0, status: deleted.contains($0) ? .deleted : .notFound) }
        return .ok(.init(body: .json(.init(results: body.results ? results : nil, summary: body.summary ? .init(requested: results.count, deleted: results.filter { $0.status == .deleted }.count, omitted: results.filter { $0.status != .deleted }.count) : nil))))
    }
}
