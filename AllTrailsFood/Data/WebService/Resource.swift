import Foundation

open class Resource<T> {
    let urlString: String
    let httpMethod: HTTPMethod
    public var parameters: [URLQueryItem]
    public var headers: [HTTPHeader]
    public var httpBodyData: Data?
    let parse: (Data) throws -> Result<T, Error>
    var etag: String?
    var authorizationToken: String?
    public var shouldEncodePlusSign: Bool = false
    
    public init(urlString: String, httpMethod: HTTPMethod = .GET, parameters: [URLQueryItem] = [], httpBodyData: Data? = nil, headers: [HTTPHeader], parse: @escaping (Data) throws -> Result<T, Error>) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.httpBodyData = httpBodyData
        self.headers = headers
        self.parse = parse
    }

    open var urlRequest: URLRequest? {
        guard let endPoint = URL(string: urlString),
              var urlComponents = URLComponents(url: endPoint, resolvingAgainstBaseURL: true) else { return nil }
        if urlComponents.queryItems != nil {
            urlComponents.queryItems?.append(contentsOf: parameters)
        } else if !parameters.isEmpty {
            urlComponents.queryItems = parameters
        }
        if shouldEncodePlusSign {
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBodyData
        request.cachePolicy = .reloadIgnoringLocalCacheData
        if let etag = etag {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        if let authorizationToken = authorizationToken {
            request.setValue("Token \(authorizationToken)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 15.0
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }  
}

open class CodableResource<T>: Resource<T> {
    public init(urlString: String, httpMethod: HTTPMethod = .GET, parameters: [URLQueryItem] = [],  httpBodyData: Data? = nil, headers: [HTTPHeader] = [], parseData: @escaping (Data) throws -> Result<T, Error>) {
        super.init(urlString: urlString, httpMethod: httpMethod, parameters: parameters, httpBodyData: httpBodyData, headers: headers,  parse:{ data in
            return try parseData(data)
        })
    }
}
