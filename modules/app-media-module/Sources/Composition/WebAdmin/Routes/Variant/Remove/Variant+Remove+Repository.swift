import FeatherWebAdmin
import MediaModule

extension Variant.Remove.Repository {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
