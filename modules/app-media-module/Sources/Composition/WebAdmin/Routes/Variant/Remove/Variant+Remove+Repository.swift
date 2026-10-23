import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Remove {
    enum Repository {}
}

extension Variant.Remove.Repository {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
