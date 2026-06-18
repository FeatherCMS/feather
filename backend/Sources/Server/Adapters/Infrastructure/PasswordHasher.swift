import Application
import BCrypt
import NIOPosix

struct BCryptPasswordHasher: PasswordHasher {

    func hash(
        _ original: String
    ) async throws -> String {
        try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash(original)
        }
    }

    func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool {
        try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().verify(original, created: hash)
        }
    }
}
