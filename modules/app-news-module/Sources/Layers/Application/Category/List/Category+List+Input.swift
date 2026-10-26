public import FeatherApplication
public import NewsModule

extension Category {
    public enum List {}
}

extension Category.List {
    public struct Input: DTO {
        public init() {}
    }
}
