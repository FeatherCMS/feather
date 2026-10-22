import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantDelete(_ input: Operations.MediaVariantDelete.Input)
        async throws -> Operations.MediaVariantDelete.Output
    {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.makeRemoveVariant()
            .execute(subject: subject, input: .init(ids: body.ids))
        return .noContent(.init())
    }
}
