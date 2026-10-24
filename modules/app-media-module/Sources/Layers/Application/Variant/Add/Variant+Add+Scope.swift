public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Variant.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let variantDefinitions: any Variant.Repository.Interface

        public init(
            variantDefinitions: any Variant.Repository.Interface
        ) {
            self.variantDefinitions = variantDefinitions
        }
    }
}
