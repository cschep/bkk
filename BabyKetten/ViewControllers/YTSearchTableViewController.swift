import UIKit

class YTSearchTableViewController: UITableViewController {
    var searchString: String = ""

    private let youTubeAPIKey = "AIzaSyC3RJ8eZ4AXCect-2RUdWMEUSdoJMOA0ds"
    private var videos: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(YTTableViewCell.self, forCellReuseIdentifier: "YTTableViewCell")

        guard let url = youTubeSearchURL() else { return }

        Task {
            let json = await NetworkManager.GET(url)
            if let dict = json as? [String: Any],
               let items = dict["items"] as? [[String: Any]] {
                self.videos = items
            }
            self.navigationItem.title = self.videos.isEmpty ? "Not Found!" : "Results"
            self.tableView.reloadData()
        }
    }

    private func youTubeSearchURL() -> URL? {
        let escaped = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(escaped)&maxResults=15&type=video&key=\(youTubeAPIKey)"
        return URL(string: urlString)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YTTableViewCell", for: indexPath) as! YTTableViewCell
        let video = videos[indexPath.row]

        if let snippet = video["snippet"] as? [String: Any] {
            cell.titleLabel.text = snippet["title"] as? String
            cell.descriptionLabel.text = snippet["description"] as? String

            if let thumbnails = snippet["thumbnails"] as? [String: Any],
               let defaultThumb = thumbnails["default"] as? [String: Any],
               let urlString = defaultThumb["url"] as? String,
               let url = URL(string: urlString) {
                cell.myImageView.setImage(from: url, placeholder: UIImage(named: "ketten_small_white")!)
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        if let id = video["id"] as? [String: Any],
           let videoId = id["videoId"] as? String,
           let url = URL(string: "https://youtube.com/watch?v=\(videoId)") {
            UIApplication.shared.open(url)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
