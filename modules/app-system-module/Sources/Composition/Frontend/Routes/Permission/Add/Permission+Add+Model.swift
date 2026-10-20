import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Add {
    struct Model: Sendable {
        let key: String
        let name: String?
        let notes: String?
    }
}
