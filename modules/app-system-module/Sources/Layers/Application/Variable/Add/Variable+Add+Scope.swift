public import FeatherModuleKit
public import SystemDomain
public import SystemModule

extension Variable.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let variable: any SystemModule.Variable.Repository.Interface
        public init(variable: any SystemModule.Variable.Repository.Interface) {
            self.variable = variable
        }
    }
}
