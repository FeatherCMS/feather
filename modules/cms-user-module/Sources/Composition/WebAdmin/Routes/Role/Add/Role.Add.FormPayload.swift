import FeatherWebAdmin
import UserModule

extension Role.Add {
    struct FormPayload: Sendable {
        let key: String
        let name: String
        let notes: String
    }
}
