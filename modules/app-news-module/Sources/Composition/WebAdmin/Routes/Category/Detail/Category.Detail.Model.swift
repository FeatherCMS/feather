import NewsApplication
import NewsModule

extension Category.Detail {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let metadata: News.Metadata.Form.Input
    }
}
