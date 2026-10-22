public import BlogDomain
public import BlogModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import WebDomain
public import WebModule

extension Author.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Author.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Interface

        public init(
            author: any Author.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Interface
        ) {
            self.author = author
            self.metadata = metadata
            self.variable = variable
        }
    }
}
