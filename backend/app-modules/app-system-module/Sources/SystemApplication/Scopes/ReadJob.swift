import Application

public struct ReadJob: Scope {
    public let job: any JobQueries

    public init(job: any JobQueries) {
        self.job = job
    }
}
