public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Variant.Processor.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let variantProcessors: any Variant.Processor.Repository.Interface

        public init(
            variantProcessors: any Variant.Processor.Repository.Interface
        ) {
            self.variantProcessors = variantProcessors
        }
    }
}
