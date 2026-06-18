import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        let useCase = modules.blog.makeGetPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogPostId)
        )

        return .ok(.init(body: .json(map(result))))
    }
}
