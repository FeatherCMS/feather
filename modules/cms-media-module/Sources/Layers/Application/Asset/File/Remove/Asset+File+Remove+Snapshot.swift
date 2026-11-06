import MediaDomain
import MediaModule

extension Asset.File.Remove {
    struct Snapshot: Sendable {
        let assets: [Asset.File.Model]
        let folders: [Asset.Folder.Model]
        let storageObjects: [Snapshot.StoredObject]
    }
}
