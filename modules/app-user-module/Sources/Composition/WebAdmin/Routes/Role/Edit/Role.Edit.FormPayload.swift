import FeatherWebAdmin
import UserModule

extension Role.Edit {
    struct FormPayload: Sendable {
        let name: String
        let notes: String
    }
}
