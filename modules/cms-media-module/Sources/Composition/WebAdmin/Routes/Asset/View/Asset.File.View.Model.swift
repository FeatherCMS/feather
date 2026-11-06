import FeatherWebAdmin
import MediaModule

extension Asset.File.View {
    struct Model: Sendable {
        let item: AdminMediaAsset
        let variants: [Variant]
    }
}
