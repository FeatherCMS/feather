public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Variant.Processor.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let variantDefinitions: any Variant.Repository.Interface
        public let variantProcessors: any Variant.Processor.Repository.Interface

        public init(
            variantDefinitions: any Variant.Repository.Interface,
            variantProcessors: any Variant.Processor.Repository.Interface
        ) {
            self.variantDefinitions = variantDefinitions
            self.variantProcessors = variantProcessors
        }
    }
}
