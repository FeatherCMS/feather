import FeatherStorage
import Foundation
import MediaApplication
import NIOCore

public struct MediaStorageClient: MediaStorage {

    let client: any StorageClient

    public init(client: any StorageClient) {
        self.client = client
    }

    public func download(
        key: String
    ) async throws -> Data {
        let sequence = try await client.download(key: key, range: nil)
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return data
    }

    public func upload(
        key: String,
        data: Data
    ) async throws {
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        try await client.upload(
            key: key,
            sequence: .init(buffer: buffer)
        )
    }

    public func delete(
        key: String
    ) async throws {
        try await client.delete(key: key)
    }
}
