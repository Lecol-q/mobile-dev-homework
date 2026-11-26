import SwiftUI
import Playgrounds
import UIKit
public import Combine


// view
struct ContentView: View {
    @State private var showingSheet = false
    @State private var selectedPost: Post?
    @ObservedObject var postObject = PostObject()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(postObject.posts.filter { $0.flow != "CORRUPT" }, id: \.id) { post in
                    if (post.private == true) {
                        Label("\(post.username) has their posts set to private", systemImage: "person.circle.fill").font(.headline)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            Label(post.username, systemImage: "person.circle.fill").font(.headline).onTapGesture {
                                selectedPost = post
                            }
                            AsyncImage(url: URL(string: post.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 250)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                Text("Fetching new posts")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 250)
                            }.onTapGesture {
                                selectedPost = post
                            }.clipShape(RoundedRectangle(cornerRadius: 12))
                            Text("🍴\(post.businessName)").font(.subheadline).fontWeight(.semibold).onTapGesture {
                                selectedPost = post
                            }
                            
                            HStack {
                                Label("+\(post.amount) points", systemImage: "star.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.orange)
                                Spacer()
                                Text("\(post.timeAgo)").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
                .sheet(item: $selectedPost) { post in
                    SheetView(post: post)
            }.onAppear {
                postObject.httpRequest()
            }
        }
        
        }.navigationTitle("PicNix").navigationBarTitleDisplayMode(.inline)
    }
}

// holds the data for each post - Model
struct Post: Codable, Identifiable {
    // json fields
    let id: Int
    let username: String
    let amount: Int
    let image: String
    let businessName: String
    let createdAt: String
    let caption: String?
    let flow: String
    let `private`: Bool
    
    var time: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        guard let date = formatter.date(from: createdAt) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    var timeAgo: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        guard let date = formatter.date(from: createdAt) else {
            return ""
        }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}

// holds array of type Post - ViewModel
class PostObject: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = true
    
    func httpRequest() {
        guard let url = URL(string: "https://www.jalirani.com/files/picnix.json") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let posts = try! JSONDecoder().decode([Post].self, from: data)
                print(posts)
                self.posts = posts
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }.resume()
        isLoading = true
    }
}

struct SheetView: View {
    let post: Post
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    AsyncImage(url: URL(string: post.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 280)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 280)
                            .overlay {
                                ProgressView()
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    HStack {
                        Label(post.username, systemImage: "person.circle.fill")
                            .font(.headline)

                        Spacer()

                        Label("+\(post.amount) points", systemImage: "star.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Restaurant")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(post.businessName)
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Date posted")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(post.time)
                            .font(.subheadline)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Caption")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(post.caption ?? "No Caption for this post")
                            .font(.body)
                    }
                }
                .padding()
            }
            .navigationTitle("Post Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background(.gray.opacity(0.12), in: Circle())
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
