public import SystemModule
public import FeatherModuleKit

extension Variable.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let variable: any Query.Interface
        public init(variable: any Query.Interface) { self.variable = variable }
    }
}
