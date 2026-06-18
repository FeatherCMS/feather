import NIOCore
import OpenAPIRuntime

extension HTTPBody {

    func collectString(
        upTo maxBytes: Int = .max
    ) async throws -> String? {
        var buffer = ByteBuffer()
        try await collect(upTo: maxBytes, into: &buffer)
        return buffer.getString(at: 0, length: buffer.readableBytes)
    }
}
