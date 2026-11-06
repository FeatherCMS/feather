import MediaDomain
import MediaModule

extension UseCases {
    struct StoredVariantFile {
        let relation: Asset.File.Variant.Model
        let definition: Variant.Model
        let object: StorageObject.Model
    }
}
