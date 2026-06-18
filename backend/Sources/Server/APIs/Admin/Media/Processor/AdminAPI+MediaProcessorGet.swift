import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaProcessorGet(
        _ input: Operations.MediaProcessorGet.Input
    ) async throws -> Operations.MediaProcessorGet.Output {
        let subject = try await CurrentSubject.require()
        guard
            let result = try await modules.media.makeGetProcessor()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaProcessorId)
                )
        else {
            return .notFound
        }

        return .ok(.init(body: .json(map(result))))
    }
}
