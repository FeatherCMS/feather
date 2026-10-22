import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case name
    }

    public func mediaFolderPatch(
        _ input: Operations.MediaFolderPatch.Input
    ) async throws -> Operations.MediaFolderPatch.Output {
        let body: Components.Schemas.MediaFolderPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }
        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )

        let subject = try await CurrentSubject.require()
        do {
            let result = try await self.useCases.makeEditFolder()
                .execute(
                    subject: subject,
                    input: .init(
                        id: input.path.mediaFolderId,
                        name: name
                    )
                )
            return .ok(.init(body: .json(map(result))))
        }
        catch let error as Asset.Folder.Edit.Error {
            switch error {
            case .notFound:
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
            case .invalidName:
                throw error
            case .duplicatePath:
                throw error
            }
        }
    }
}
