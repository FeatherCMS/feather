import NewsApplication
import NewsModule

extension Article.Detail {
    struct Model: Sendable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let categoryIDs: [String]
        let metadata: News.Metadata.Form.Input
    }
}
