public import FeatherApplication
public import NewsModule

extension Article {
    public enum List {}
}

extension Article.List {
    public struct Input: DTO {
        public init() {}
    }
}
