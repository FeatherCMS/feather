public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func blogPostDelete(
        _ input: Operations.BlogPostDelete.Input
    ) async throws -> Operations.BlogPostDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemovePost()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
