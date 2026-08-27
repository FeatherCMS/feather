import BCrypt
import FeatherDomain
import NIOPosix

public struct BCryptPasswordHasher: PasswordHasher {

    public init() {}

    public func hash(
        _ original: String
    ) async throws -> String {
        try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash(original)
        }
    }

    public func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool {
        try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().verify(original, created: hash)
        }
    }
}
