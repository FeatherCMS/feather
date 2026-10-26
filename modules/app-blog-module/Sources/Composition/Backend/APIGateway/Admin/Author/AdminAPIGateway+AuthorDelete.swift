public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import WebApplication

extension AdminAPIGateway {
    public func blogAuthorDelete(
        _ input: Operations.BlogAuthorDelete.Input
    ) async throws -> Operations.BlogAuthorDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeRemoveAuthor()
        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
