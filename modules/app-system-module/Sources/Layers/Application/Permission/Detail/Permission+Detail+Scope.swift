public import FeatherModuleKit
public import SystemModule

extension Permission.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any Permission.Detail.Query.Interface

        public init(permission: any Permission.Detail.Query.Interface) {
            self.permission = permission
        }
    }
}
