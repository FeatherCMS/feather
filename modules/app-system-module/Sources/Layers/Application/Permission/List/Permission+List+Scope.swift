public import SystemModule
public import FeatherModuleKit

extension Permission.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any Permission.List.Query.Interface

        public init(permission: any Permission.List.Query.Interface) {
            self.permission = permission
        }
    }
}
