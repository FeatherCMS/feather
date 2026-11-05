import NewsApplication
import NewsModule

extension Category.Remove.Request {
    struct Input: Decodable, Sendable {
        let id: String
    }
}
