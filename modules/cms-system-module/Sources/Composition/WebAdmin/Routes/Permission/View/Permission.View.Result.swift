import FeatherWebAdmin
import SystemModule

extension Permission.View {
    struct Result: Sendable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
    }
}
