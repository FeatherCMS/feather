import FeatherModuleKit
import WebModule

extension Menu.Public.List {
    public struct Action: PermissionAction {
        public let key: PermissionKey

        public init(key: PermissionKey) {
            self.key = key
        }
    }
}
