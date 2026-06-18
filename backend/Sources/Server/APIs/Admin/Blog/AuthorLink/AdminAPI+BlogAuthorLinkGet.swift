import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorLinkGet(
        _ input: Operations.BlogAuthorLinkGet.Input
    ) async throws -> Operations.BlogAuthorLinkGet.Output {
        let useCase = modules.blog.makeGetAuthorLink()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
