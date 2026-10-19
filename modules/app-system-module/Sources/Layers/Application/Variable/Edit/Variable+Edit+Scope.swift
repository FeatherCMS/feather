public import SystemModule
public import FeatherModuleKit
public import SystemDomain

extension Variable.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let variable: any SystemModule.Variable.Repository.Interface
        public init(variable: any SystemModule.Variable.Repository.Interface) {
            self.variable = variable
        }
    }
}
