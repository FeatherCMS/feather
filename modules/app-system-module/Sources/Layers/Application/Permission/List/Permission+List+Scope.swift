public import FeatherModuleKit
public import SystemModule

extension Permission.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any Query.Interface

        public init(permission: any Query.Interface) {
            self.permission = permission
        }
    }
}
