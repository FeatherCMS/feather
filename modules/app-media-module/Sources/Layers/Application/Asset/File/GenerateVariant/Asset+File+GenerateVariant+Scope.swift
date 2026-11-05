public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Asset.File.GenerateVariant {
    public struct Scope: FeatherModuleKit.Scope {
        public let assets: any Asset.File.Repository.Interface
        public let storageObjects: any StorageObject.Repository.Interface
        public let variants: any Asset.File.Variant.Repository.Interface
        public let variantDefinitions: any Variant.Repository.Interface
        public let variantProcessors: any Variant.Processor.Repository.Interface

        public init(
            assets: any Asset.File.Repository.Interface,
            storageObjects: any StorageObject.Repository.Interface,
            variants: any Asset.File.Variant.Repository.Interface,
            variantDefinitions: any Variant.Repository.Interface,
            variantProcessors: any Variant.Processor.Repository.Interface
        ) {
            self.assets = assets
            self.storageObjects = storageObjects
            self.variants = variants
            self.variantDefinitions = variantDefinitions
            self.variantProcessors = variantProcessors
        }
    }
}
