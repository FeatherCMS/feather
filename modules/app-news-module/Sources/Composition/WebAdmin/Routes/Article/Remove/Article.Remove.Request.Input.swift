import NewsApplication
import NewsModule

extension Article.Remove.Request {
    struct Input: Decodable, Sendable {
        let id: String
    }
}
