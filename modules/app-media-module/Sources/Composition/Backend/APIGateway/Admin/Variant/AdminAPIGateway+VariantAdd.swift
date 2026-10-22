import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantPost(_ input: Operations.MediaVariantPost.Input)
        async throws -> Operations.MediaVariantPost.Output
    {
        let body: Components.Schemas.MediaVariantCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeAddVariant()
            .execute(
                subject: subject,
                input: .init(
                    key: body.key,
                    name: body.name,
                    isRequired: body.isRequired,
                    isActive: body.isActive
                )
            )
        return .created(.init(body: .json(map(result.detail))))
    }
}
