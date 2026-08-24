import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaProcessorDelete(
        _ input: Operations.MediaProcessorDelete.Input
    ) async throws -> Operations.MediaProcessorDelete.Output {
        let subject = try await CurrentSubject.require()
        let isDeleted = try await self.useCases.makeDeleteProcessor()
            .execute(
                subject: subject,
                input: .init(id: input.path.mediaProcessorId)
            )
        return isDeleted ? .noContent : .notFound
    }
}
