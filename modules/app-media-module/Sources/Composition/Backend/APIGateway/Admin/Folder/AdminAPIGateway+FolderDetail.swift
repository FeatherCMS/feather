import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderGet(
        _ input: Operations.MediaFolderGet.Input
    ) async throws -> Operations.MediaFolderGet.Output {
        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeDetailFolder()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaFolderId)
                )
            return .ok(.init(body: .json(map(result))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        errorEnvelope(
                            message: "Media folder not found.",
                            reason: "media_folder_not_found"
                        )
                    )
                )
            )
        }
    }
}
