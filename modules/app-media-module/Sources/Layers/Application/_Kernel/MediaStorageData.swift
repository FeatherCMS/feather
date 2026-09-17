import FeatherStorage
import Foundation
import NIOCore

public enum MediaStorageData {
    public static func upload(
        _ data: Data,
        to storage: any StorageClient,
        key: String
    ) async throws {
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        try await storage.upload(
            key: key,
            sequence: .init(buffer: buffer)
        )
    }

    public static func download(
        from storage: any StorageClient,
        key: String
    ) async throws -> Data {
        let sequence = try await storage.download(key: key, range: nil)
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return data
    }

    public static func delete(
        from storage: any StorageClient,
        key: String
    ) async throws {
        try await storage.delete(key: key)
    }
}
