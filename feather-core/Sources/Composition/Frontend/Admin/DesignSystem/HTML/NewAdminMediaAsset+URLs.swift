import Foundation
import FeatherContracts

extension NewAdminMediaAsset {
    public static func mediaURL(path: String) -> String {
        unsafe AppEnvironmentStore.current.mediaResolver.resolve(imagePath: path)
            ?? path
    }
}
