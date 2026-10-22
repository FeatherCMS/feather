public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorLinkPost(
        _ input: Operations.BlogAuthorLinkPost.Input
    ) async throws -> Operations.BlogAuthorLinkPost.Output {
        let body: Components.Schemas.AuthorLinkPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                authorId: input.path.blogAuthorId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes ?? ""
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
