import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaProcessorUpdate(
        _ input: Operations.MediaProcessorUpdate.Input
    ) async throws -> Operations.MediaProcessorUpdate.Output {
        let body: Components.Schemas.MediaProcessorCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await modules.media.makeEditProcessor()
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
