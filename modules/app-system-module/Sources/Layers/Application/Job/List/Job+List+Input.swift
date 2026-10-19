public import SystemModule
public import FeatherApplication

extension Job.List {
    public struct Input: DTO {
        public let page: Search.Page

        public init(page: Search.Page = .init()) {
            self.page = page
        }
    }
}
