import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorDelete(
        _ input: Operations.BlogAuthorDelete.Input
    ) async throws -> Operations.BlogAuthorDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.blog.makeRemoveAuthor()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogAuthorId)
        )

        return .noContent(.init())
    }
}
