import Foundation
import FeatherContracts

extension NewAdminMediaAsset {
    public static func mediaURL(path: String) -> String {
        AppEnvironmentStore.current.mediaResolver.resolve(imagePath: path)
            ?? path
    }
}
