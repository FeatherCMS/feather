enum SystemJobStatus {
    struct Option: Sendable {
        let value: Int
        let label: String
    }

    static let options: [Option] = [
        .init(value: 0, label: "Pending"),
        .init(value: 1, label: "Processing"),
        .init(value: 2, label: "Failed"),
        .init(value: 3, label: "Cancelled"),
        .init(value: 4, label: "Paused"),
        .init(value: 5, label: "Completed"),
    ]
}
