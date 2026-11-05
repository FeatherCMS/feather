import AnalyticsModule

extension Overview {
    struct Model: Sendable {
        let query: Query
        let kpis: KPIs
        let daily: [DailyPoint]
        let methods: [BreakdownItem]
        let paths: [BreakdownItem]
        let notFoundPaths: [BreakdownItem]
        let serverErrorPaths: [BreakdownItem]
        let referrers: [BreakdownItem]
        let browsers: [BreakdownItem]
        let operatingSystems: [BreakdownItem]
        let deviceTypes: [BreakdownItem]
        let languages: [BreakdownItem]
        let regions: [BreakdownItem]
    }
}
