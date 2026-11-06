public import FeatherModuleKit
public import WebModule

extension Menu.Public.Detail {
    public struct Action: PermissionAction {
        public let key: PermissionKey

        public init(key: PermissionKey) {
            self.key = key
        }
    }
}
