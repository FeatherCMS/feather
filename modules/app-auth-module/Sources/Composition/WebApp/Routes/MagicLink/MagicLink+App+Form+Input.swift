import AuthModule
import FeatherWebAdmin

extension MagicLink.App.Form {
    struct Input: Codable, Sendable {
        let email: String
        let isPersistent: AdminFormFieldCheckbox.Input

        enum CodingKeys: String, CodingKey {
            case email
            case isPersistent = "is_persistent"
        }
    }
}
