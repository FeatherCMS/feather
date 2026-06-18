import AnalyticsDomain
import Application

public struct WriteLog: Scope {
    public let log: any LogRepository

    public init(log: any LogRepository) {
        self.log = log
    }
}
