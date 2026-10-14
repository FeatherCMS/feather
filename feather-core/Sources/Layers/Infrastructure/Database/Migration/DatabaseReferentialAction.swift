public enum DatabaseReferentialAction: Sendable {
    case noAction
    case restrict
    case cascade
    case setNull
    case setDefault
}
