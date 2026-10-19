import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataRemove(
        _ input: Operations.WebMetadataRemove.Input
    ) async throws -> Operations.WebMetadataRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeRemoveMetadata()
        let subject = try await CurrentSubject.require()

        _ = try await useCase.execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }
}
