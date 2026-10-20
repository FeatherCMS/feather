public import FeatherApplication
public import SystemModule

extension Job.Search {
    public struct Output: DTO, Sendable {
        public let items: [Job.Detail.Output]
        public let total: Int

        public init(items: [Job.Detail.Output], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
