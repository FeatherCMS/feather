import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaFolderGet(
        _ input: Operations.MediaFolderGet.Input
    ) async throws -> Operations.MediaFolderGet.Output {
        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.makeGetFolder()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaFolderId)
                )
            return .ok(.init(body: .json(map(result))))
        }
        catch {
            return .notFound(.init())
        }
    }
}
