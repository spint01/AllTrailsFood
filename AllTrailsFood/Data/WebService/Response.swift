import Foundation

public struct Response<T, WebServiceError> {
    public var httpURLResponse: HTTPURLResponse?
    public var result: Result<T, WebServiceError>

    public init(httpURLResponse: HTTPURLResponse?, result: Result<T, WebServiceError>) {
        self.httpURLResponse = httpURLResponse
        self.result = result
    }

    public var etag: String? {
        return httpURLResponse?.allHeaderFields.first(where: {
            ($0.key as? String)?.caseInsensitiveCompare("etag") == .orderedSame
        })?.value as? String
    }

    public var lastModifiedDateString: String? {
        return httpURLResponse?.value(forHTTPHeaderField: "Last-Modified")
    }
}
