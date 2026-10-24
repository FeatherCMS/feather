import FeatherWebAdmin
import SystemModule

extension Variable.Edit {
    struct Model: Sendable {
        let id: String
        let key: String
        let value: String
        let name: String?
        let notes: String?
    }
}
