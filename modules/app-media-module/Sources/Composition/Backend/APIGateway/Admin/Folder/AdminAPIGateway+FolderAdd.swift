import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaFolderPost(
        _ input: Operations.MediaFolderPost.Input
    ) async throws -> Operations.MediaFolderPost.Output {
        let body: Components.Schemas.MediaFolderCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeAddFolder()
                .execute(
                    subject: subject,
                    input: .init(
                        parentId: (body.parentId ?? "").emptyToNil,
                        name: body.name
                    )
                )
            return .created(.init(body: .json(map(result.detail))))
        }
        catch let error as Asset.Folder.Add.Error {
            switch error {
            case .duplicatePath:
                return .conflict(
                    .init(
                        body: .json(
                            errorEnvelope(
                                message:
                                    "A media folder with this name already exists.",
                                reason: "media_folder_conflict"
                            )
                        )
                    )
                )
            case .invalidName, .parentNotFound:
                throw error
            }
        }
    }
}
