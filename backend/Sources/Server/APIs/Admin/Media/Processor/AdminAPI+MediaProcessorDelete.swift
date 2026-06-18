import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaProcessorDelete(
        _ input: Operations.MediaProcessorDelete.Input
    ) async throws -> Operations.MediaProcessorDelete.Output {
        let subject = try await CurrentSubject.require()
        let isDeleted = try await modules.media.makeDeleteProcessor()
            .execute(
                subject: subject,
                input: .init(id: input.path.mediaProcessorId)
            )
        return isDeleted ? .noContent : .notFound
    }
}
