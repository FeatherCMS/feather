public import FeatherModuleKit
public import SystemModule

extension Variable.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let variable: any Variable.Search.Interface

        public init(variable: any Variable.Search.Interface) {
            self.variable = variable
        }
    }
}
