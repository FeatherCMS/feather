import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantRemove(_ input: Operations.MediaVariantRemove.Input)
        async throws -> Operations.MediaVariantRemove.Output
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
