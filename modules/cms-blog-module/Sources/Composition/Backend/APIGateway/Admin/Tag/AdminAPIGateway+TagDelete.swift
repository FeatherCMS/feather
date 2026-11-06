public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func blogTagDelete(
        _ input: Operations.BlogTagDelete.Input
    ) async throws -> Operations.BlogTagDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveTag()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
