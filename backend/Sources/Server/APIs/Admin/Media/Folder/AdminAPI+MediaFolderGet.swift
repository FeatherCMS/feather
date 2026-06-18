import Application
import MediaApplication
import AdminOpenAPI

extension AdminAPI {
    func mediaFolderGet(
        _ input: Operations.MediaFolderGet.Input
    ) async throws -> Operations.MediaFolderGet.Output {
        let subject = try await CurrentSubject.require()
        do {
            let result = try await modules.media.makeGetFolder()
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
