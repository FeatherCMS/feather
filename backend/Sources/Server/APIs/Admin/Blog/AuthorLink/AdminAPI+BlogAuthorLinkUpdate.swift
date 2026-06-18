import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorLinkUpdate(
        _ input: Operations.BlogAuthorLinkUpdate.Input
    ) async throws -> Operations.BlogAuthorLinkUpdate.Output {
        let body: Components.Schemas.BlogAuthorLinkCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId,
                label: body.label,
                url: body.url,
                priority: body.priority,
                isBlank: body.isBlank,
                permission: body.permission,
                notes: body.notes
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
