import FeatherContracts
import Foundation
public import MediaAdminAPI
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
        let result = try await useCases.createAssetAndEnqueue(
            subject: subject,
            input: .init(
                folderId: body.parentId.flatMap { $0 }
                    .flatMap { $0.emptyToNil },
                fileName: body.fileName,
                extension: body._extension,
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
