public import AuthModule

extension AuthModule {
    public enum Auth {}
    public enum Authorization {
        public enum CurrentUser {}
        public enum Query {}
    }
}

extension AuthModule.Auth {
    public enum SignIn {}
    public enum TokenAuth {}
}

extension AuthModule.Auth.SignIn {
    public enum Credentials {}
    public enum MagicLink {}
}
