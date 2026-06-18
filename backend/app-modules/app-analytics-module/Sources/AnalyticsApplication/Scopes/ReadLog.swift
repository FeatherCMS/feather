import Application

public struct ReadLog: Scope {
    public let log: any LogQueries

    public init(log: any LogQueries) {
        self.log = log
    }
}
