import Application
import MediaApplication
import AdminOpenAPI

extension AdminAPI {
    func mediaFolderDelete(
        _ input: Operations.MediaFolderDelete.Input
    ) async throws -> Operations.MediaFolderDelete.Output {
        let subject = try await CurrentSubject.require()
        let deleted = try await modules.media.makeDeleteFolder()
            .execute(
                subject: subject,
                input: .init(id: input.path.mediaFolderId)
            )
        return deleted ? .noContent : .notFound(.init())
    }
}
