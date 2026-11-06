extension Log {
    public enum Filter {
        public protocol Interface: Sendable {
            func shouldTrack(
                path: String,
                method: String,
                responseCode: Int
            ) -> Bool
        }
    }
}
