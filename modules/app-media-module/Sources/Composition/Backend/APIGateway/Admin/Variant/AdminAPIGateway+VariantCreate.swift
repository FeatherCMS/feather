import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantCreate(_ input: Operations.MediaVariantCreate.Input)
        async throws -> Operations.MediaVariantCreate.Output
    {
        let body: Components.Schemas.MediaVariantCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeCreateVariant()
            .execute(
                subject: subject,
                input: .init(
                    variant: .init(
                        key: body.key,
                        name: body.name,
                        isRequired: body.isRequired,
                        isActive: body.isActive
                    )
                )
            )
        return .created(.init(body: .json(map(result))))
    }
}
