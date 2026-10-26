import FeatherModuleKit
import FeatherStorage
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule
import NIOCore
import OpenAPIRuntime

extension AdminAPIGateway {
    private enum MediaAssetUploadError: Error, Sendable {
        case contentLengthRequired
    }

    private struct MediaStorageSequence: Sendable, AsyncSequence {
        struct AsyncIterator: AsyncIteratorProtocol {
            var iterator: HTTPBody.AsyncIterator

            mutating func next() async throws -> ByteBuffer? {
                let bytes = try await iterator.next(isolation: nil)
                guard let bytes else {
                    return nil
                }
                return ByteBuffer(bytes: bytes)
            }
        }

        let body: HTTPBody

        func makeAsyncIterator() -> AsyncIterator {
            .init(iterator: body.makeAsyncIterator())
        }
    }

    public func mediaAssetPost(
        _ input: Operations.MediaAssetPost.Input
    ) async throws -> Operations.MediaAssetPost.Output {
        let body: HTTPBody
        switch input.body {
        case .binary(let value):
            body = value
        }
        guard case .known(let contentLength) = body.length else {
            throw MediaAssetUploadError.contentLengthRequired
        }
        let storageSequence = StorageSequence(
            asyncSequence: MediaStorageSequence(body: body),
            length: UInt64(contentLength)
        )
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeAddAsset()
                .execute(
                    subject: subject,
                    input: .init(
                        folderId: input.headers.xMediaAssetParentID?.emptyToNil,
                        fileName: input.headers.xMediaAssetFileName,
                        extension: input.headers.xMediaAssetExtension,
                        title: input.headers.xMediaAssetTitle?.emptyToNil,
                        altText: input.headers.xMediaAssetAltText?.emptyToNil,
                        content: storageSequence,
                        contentLength: contentLength
                    )
                )

            return .created(
                .init(
                    body: .json(mapAddedAsset(result))
                )
            )
        }
        catch let error as Asset.File.Add.Error {
            switch error {
            case .duplicatePath:
                return .conflict(
                    .init(
                        body: .json(
                            .init(
                                error: .init(
                                    message:
                                        "A media asset already exists at this path.",
                                    reason: "media_asset_conflict"
                                )
                            )
                        )
                    )
                )
            }
        }
    }

    private func mapAddedAsset(
        _ detail: Asset.File.Add.Output
    ) -> Components.Schemas.MediaAssetDetailSchema {
        .init(
            id: detail.id,
            folderId: detail.folderId,
            name: detail.name,
            slug: detail.slug,
            slugPath: detail.slugPath,
            url: mediaResolver.resolve(imagePath: detail.url) ?? detail.url,
            _extension: detail.extension,
            contentType: detail.contentType,
            sizeBytes: detail.sizeBytes,
            status: detail.status,
            title: detail.title,
            altText: detail.altText,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
