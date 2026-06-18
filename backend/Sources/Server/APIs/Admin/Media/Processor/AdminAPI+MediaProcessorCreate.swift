import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaProcessorCreate(
        _ input: Operations.MediaProcessorCreate.Input
    ) async throws -> Operations.MediaProcessorCreate.Output {
        let body: Components.Schemas.MediaProcessorCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await modules.media.makeCreateProcessor()
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
