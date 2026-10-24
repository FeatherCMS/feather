import FeatherWebAdmin
import SystemModule

extension Permission.Add {
    struct Model: Sendable {
        let key: String
        let name: String?
        let notes: String?
    }
}
