import Foundation

public protocol MediaStorage: Sendable {
    func download(
        key: String
    ) async throws -> Data
    func upload(
        key: String,
        data: Data
    ) async throws
    func delete(
        key: String
    ) async throws
}
