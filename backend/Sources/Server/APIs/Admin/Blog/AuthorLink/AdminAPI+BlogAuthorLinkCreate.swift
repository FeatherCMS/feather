import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorLinkCreate(
        _ input: Operations.BlogAuthorLinkCreate.Input
    ) async throws -> Operations.BlogAuthorLinkCreate.Output {
        let body: Components.Schemas.BlogAuthorLinkCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeAddAuthorLink()
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
