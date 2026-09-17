import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantUpdate(_ input: Operations.MediaVariantUpdate.Input) async throws -> Operations.MediaVariantUpdate.Output {
        let body: Components.Schemas.MediaVariantCreateSchema
        switch input.body { case .json(let value): body = value }
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeEditVariant().execute(
                subject: subject,
                input: .init(id: input.path.mediaVariantId, variant: .init(key: body.key, name: body.name, isRequired: body.isRequired, isActive: body.isActive))
            )
            return .ok(.init(body: .json(map(result))))
        }
        catch EditMediaVariant.Error.notFound {
            return .notFound
        }
    }
}
