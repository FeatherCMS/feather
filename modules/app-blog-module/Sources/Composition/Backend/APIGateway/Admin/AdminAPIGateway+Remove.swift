public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorRemove(
        _ input: Operations.BlogAuthorRemove.Input
    ) async throws -> Operations.BlogAuthorRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveAuthor()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }

    public func blogAuthorLinkRemove(
        _ input: Operations.BlogAuthorLinkRemove.Input
    ) async throws -> Operations.BlogAuthorLinkRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveAuthorLink()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids, authorId: input.path.blogAuthorId)
        )
        return .noContent(.init())
    }

    public func blogPostRemove(
        _ input: Operations.BlogPostRemove.Input
    ) async throws -> Operations.BlogPostRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePost()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }

    public func blogTagRemove(
        _ input: Operations.BlogTagRemove.Input
    ) async throws -> Operations.BlogTagRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveTag()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
