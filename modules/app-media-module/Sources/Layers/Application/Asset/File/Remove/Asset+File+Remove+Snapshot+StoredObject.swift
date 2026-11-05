import MediaDomain
import MediaModule

extension Asset.File.Remove.Snapshot {
    struct StoredObject: Sendable {
        let assetId: String
        let object: StorageObject.Model
    }
}
