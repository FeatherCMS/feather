import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetCreate(
        _ input: Operations.MediaAssetCreate.Input
    ) async throws -> Operations.MediaAssetCreate.Output {
        let body: Components.Schemas.MediaAssetCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let data = Data(base64Encoded: body.data) ?? Data(body.data.utf8)
        let subject = try await CurrentSubject.require()
        let storage = try await useCases.composeAssetStorageKey(
            fileName: body.fileName,
            type: body._type,
            folderId: body.parentId.flatMap { $0 }.flatMap { $0.emptyToNil }
        )
        let result = try await useCases.createAssetAndEnqueue(
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
