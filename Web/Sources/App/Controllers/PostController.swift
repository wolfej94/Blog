import Fluent
import Vapor
import Logic

struct PostController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("posts")
        posts.post(use: create)
        posts.get(use: getAll)
        posts.group(":id") { post in
            post.get(use: getByID)
            post.delete(use: delete)
        }
    }
    
    func getAll(req: Request) async throws -> [PostResponse] {
        try req.auth.require(User.self)
        let posts = try await Post.query(on: req.db)
            .sort(\.$createdAt, .ascending)
            .all()
            .map { $0.response }
        return posts
    }
    
    func getByID(req: Request) async throws -> PostResponse {
        try req.auth.require(User.self)
        guard let post = try await Post.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return post.response
    }

    func create(req: Request) async throws -> PostResponse {
        let user = try req.auth.require(User.self)
        try PostRequest.validate(content: req)
        let create = try req.content.decode(PostRequest.self)
        let post = Post(
            title: create.title,
            body: create.body,
            userID: user.id!)
        try await post.save(on: req.db)
        return post.response
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let id = req.parameters.get("id"), let uid = UUID(uuidString: id) else {
            throw Abort(.badRequest)
        }
        guard let post = try await user.$posts.query(on: req.db)
            .filter(\.$id == uid)
            .first() else {
            throw Abort(.notFound)
        }
        try await post.delete(on: req.db)
        return .noContent
    }
    
}
