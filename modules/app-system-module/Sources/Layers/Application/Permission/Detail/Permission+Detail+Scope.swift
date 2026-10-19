public import SystemModule
public import FeatherModuleKit

extension Permission.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any Permission.Detail.Query.Interface

        public init(permission: any Permission.Detail.Query.Interface) {
            self.permission = permission
        }
    }
}
