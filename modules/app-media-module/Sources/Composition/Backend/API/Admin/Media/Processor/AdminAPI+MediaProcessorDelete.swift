import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaProcessorDelete(
        _ input: Operations.MediaProcessorDelete.Input
    ) async throws -> Operations.MediaProcessorDelete.Output {
        let subject = try await CurrentSubject.require()
        let isDeleted = try await self.makeDeleteProcessor()
            .execute(
                subject: subject,
                input: .init(id: input.path.mediaProcessorId)
            )
        return isDeleted ? .noContent : .notFound
    }
}
