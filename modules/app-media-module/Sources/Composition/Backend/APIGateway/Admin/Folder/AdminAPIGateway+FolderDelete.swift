import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderDelete(
        _ input: Operations.MediaFolderDelete.Input
    ) async throws -> Operations.MediaFolderDelete.Output {
        let subject = try await CurrentSubject.require()
        let deleted = try await self.useCases.makeDeleteFolder()
            .execute(
                subject: subject,
                input: .init(id: input.path.mediaFolderId)
            )
        return deleted ? .noContent : .notFound(.init())
    }
}
