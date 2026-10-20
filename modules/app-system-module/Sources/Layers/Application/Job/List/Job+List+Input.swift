public import FeatherApplication
public import SystemModule

extension Job.List {
    public struct Input: DTO {
        public let page: Search.Page

        public init(page: Search.Page = .init()) {
            self.page = page
        }
    }
}
