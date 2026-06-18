import AdminOpenAPI
import Application
import MediaApplication
import Foundation

extension AdminAPI {
    func mediaAssetCreate(
        _ input: Operations.MediaAssetCreate.Input
    ) async throws -> Operations.MediaAssetCreate.Output {
        let body: Components.Schemas.MediaAssetCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let data = Data(base64Encoded: body.data) ?? Data(body.data.utf8)
        let subject = try await CurrentSubject.require()
        let storage = try await modules.media.composeAssetStorageKey(
            fileName: body.fileName,
            type: body._type,
            folderId: emptyToNil(body.parentId ?? "")
        )
        let result = try await modules.media.createAssetAndEnqueue(
            subject: subject,
            input: .init(
                folderId: storage.folderId,
                storageKey: storage.storageKey,
                type: body._type,
                title: body.title,
                altText: body.altText,
                data: data
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
