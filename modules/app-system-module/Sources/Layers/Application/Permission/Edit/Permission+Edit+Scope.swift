public import SystemModule
public import FeatherModuleKit
public import SystemDomain

extension Permission.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let permission: any SystemModule.Permission.Repository.Interface

        public init(
            permission: any SystemModule.Permission.Repository.Interface
        ) {
            self.permission = permission
        }
    }
}
