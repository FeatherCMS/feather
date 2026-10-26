public import FeatherApplication
import NewsModule

extension Public.Category.Detail {
    public struct Input: DTO {
        public let id: String
        public let pageNumber: Int
        public let pageSize: Int

        public init(
            id: String,
            pageNumber: Int = 1,
            pageSize: Int = 10000
        ) {
            self.id = id
            self.pageNumber = pageNumber
            self.pageSize = pageSize
        }
    }
}
