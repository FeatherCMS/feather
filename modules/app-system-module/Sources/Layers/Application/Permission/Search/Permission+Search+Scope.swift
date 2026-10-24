public import FeatherModuleKit
public import SystemModule

extension Permission.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any Permission.Search.Query.Interface

        public init(permission: any Permission.Search.Query.Interface) {
            self.permission = permission
        }
    }
}
