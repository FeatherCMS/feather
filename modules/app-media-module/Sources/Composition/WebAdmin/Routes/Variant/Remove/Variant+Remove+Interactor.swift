import FeatherWebAdmin
import MediaModule

extension Variant.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
