import FeatherContracts
import FeatherStorage
public import MediaAdminAPI
import MediaApplication
import NIOCore
import OpenAPIRuntime

private enum MediaAssetUploadError: Error, Sendable {
    case contentLengthRequired
}

private struct MediaStorageSequence: Sendable, AsyncSequence {
    typealias Element = ByteBuffer

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

extension AdminAPIGateway {
    public func mediaAssetCreate(
        _ input: Operations.MediaAssetCreate.Input
    ) async throws -> Operations.MediaAssetCreate.Output {
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
        let result = try await useCases.createAssetAndEnqueue(
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
                body: .json(map(result))
            )
        )
    }
}
