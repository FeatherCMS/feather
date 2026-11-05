public import FeatherModuleKit
public import SystemModule

extension Variable.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let variable: any Query.Interface

        public init(variable: any Query.Interface) {
            self.variable = variable
        }
    }
}
