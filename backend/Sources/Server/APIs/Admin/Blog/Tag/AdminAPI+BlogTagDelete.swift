import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogTagDelete(
        _ input: Operations.BlogTagDelete.Input
    ) async throws -> Operations.BlogTagDelete.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.blog.makeRemoveTag()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogTagId)
        )

        return .noContent(.init())
    }
}
