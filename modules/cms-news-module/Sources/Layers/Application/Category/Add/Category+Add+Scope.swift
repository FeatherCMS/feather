public import FeatherModuleKit
public import NewsDomain
public import NewsModule
public import SystemApplication
public import SystemModule
public import WebDomain
public import WebModule

extension Category.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Category.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Query.Interface

        public init(
            category: any Category.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Query.Interface
        ) {
            self.category = category
            self.metadata = metadata
            self.variable = variable
        }
    }
}
