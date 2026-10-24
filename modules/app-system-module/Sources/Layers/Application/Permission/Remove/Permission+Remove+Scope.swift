public import FeatherModuleKit
public import SystemDomain
public import SystemModule

extension Permission.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any SystemModule.Permission.Repository.Interface

        public init(
            permission: any SystemModule.Permission.Repository.Interface
        ) {
            self.permission = permission
        }
    }
}
