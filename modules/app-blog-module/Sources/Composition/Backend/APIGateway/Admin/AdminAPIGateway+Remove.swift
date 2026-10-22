public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorDelete(
        _ input: Operations.BlogAuthorDelete.Input
    ) async throws -> Operations.BlogAuthorDelete.Output {
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

    public func blogAuthorLinkDelete(
        _ input: Operations.BlogAuthorLinkDelete.Input
    ) async throws -> Operations.BlogAuthorLinkDelete.Output {
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

    public func blogPostDelete(
        _ input: Operations.BlogPostDelete.Input
    ) async throws -> Operations.BlogPostDelete.Output {
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

    public func blogTagDelete(
        _ input: Operations.BlogTagDelete.Input
    ) async throws -> Operations.BlogTagDelete.Output {
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
