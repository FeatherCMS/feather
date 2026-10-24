public import BlogDomain
public import BlogModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import WebDomain
public import WebModule

extension Tag.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Query.Interface

        public init(
            tag: any Tag.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Query.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
            self.variable = variable
        }
    }
}
