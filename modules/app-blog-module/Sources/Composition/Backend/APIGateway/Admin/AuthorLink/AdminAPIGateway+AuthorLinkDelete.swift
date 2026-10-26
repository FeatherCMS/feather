public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import WebApplication

extension AdminAPIGateway {
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
}
