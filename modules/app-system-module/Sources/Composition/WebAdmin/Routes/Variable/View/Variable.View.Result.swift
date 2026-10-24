import FeatherWebAdmin
import SystemModule

extension Variable.View {
    struct Result: Sendable {
        let id: String
        let key: String
        let value: String
        let name: String?
        let notes: String?
    }
}
