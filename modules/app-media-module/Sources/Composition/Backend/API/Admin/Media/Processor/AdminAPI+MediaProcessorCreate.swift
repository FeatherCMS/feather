import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaProcessorCreate(
        _ input: Operations.MediaProcessorCreate.Input
    ) async throws -> Operations.MediaProcessorCreate.Output {
        let body: Components.Schemas.MediaProcessorCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.makeCreateProcessor()
            .execute(
                subject: subject,
                input: .init(
                    processor: .init(
                        name: body.name,
                        matchExtensions: body.matchExtensions,
                        commandTemplate: body.commandTemplate
                    )
                )
            )

        return .created(.init(body: .json(map(result))))
    }
}
