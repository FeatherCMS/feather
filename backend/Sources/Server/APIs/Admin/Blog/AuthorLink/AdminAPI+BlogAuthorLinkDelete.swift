import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorLinkDelete(
        _ input: Operations.BlogAuthorLinkDelete.Input
    ) async throws -> Operations.BlogAuthorLinkDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.blog.makeRemoveAuthorLink()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorLinkId,
                authorId: input.path.blogAuthorId
            )
        )

        return .noContent(.init())
    }
}
