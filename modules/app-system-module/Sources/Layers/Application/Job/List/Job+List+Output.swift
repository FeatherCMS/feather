public import SystemModule
public import FeatherApplication

extension Job.List {
    public struct Output: DTO, Sendable {
        public let items: [Job.Detail.Output]
        public init(items: [Job.Detail.Output]) { self.items = items }
    }
}
