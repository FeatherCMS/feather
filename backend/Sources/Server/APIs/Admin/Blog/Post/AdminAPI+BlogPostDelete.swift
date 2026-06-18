import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogPostDelete(
        _ input: Operations.BlogPostDelete.Input
    ) async throws -> Operations.BlogPostDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.blog.makeRemovePost()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogPostId)
        )

        return .noContent(.init())
    }
}
