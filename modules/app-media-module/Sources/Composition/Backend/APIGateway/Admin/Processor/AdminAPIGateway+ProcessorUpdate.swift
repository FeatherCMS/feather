import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaProcessorUpdate(
        _ input: Operations.MediaProcessorUpdate.Input
    ) async throws -> Operations.MediaProcessorUpdate.Output {
        let body: Components.Schemas.MediaProcessorCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeEditProcessor()
            .execute(
                subject: subject,
                input: .init(
                    id: input.path.mediaProcessorId,
                    name: body.name,
                    matchExtensions: body.matchExtensions,
                    commandTemplate: body.commandTemplate
                )
            )

        return .ok(.init(body: .json(map(result))))
    }
}
