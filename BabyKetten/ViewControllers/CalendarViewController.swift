import UIKit

class CalendarViewController: UITableViewController {
    var onEventSelected: ((CalendarEvent) -> Void)?

    private var dateList: [CalendarEvent] = []

    private let seattleCalendarId = "b73eparqatr3h2160l7i298tas@group.calendar.google.com"
    private let portlandCalendarId = "9a434tnlm9mbo57r05rkodl6d0@group.calendar.google.com"
    private let googleCalendarAPIKey = "AIzaSyC3RJ8eZ4AXCect-2RUdWMEUSdoJMOA0ds"

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadDates), for: .valueChanged)
        self.refreshControl = refreshControl

        let spinner = SpinnerViewController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner.view)

        navigationItem.title = "loading..."
        loadDates()
    }

    @objc private func loadDates() {
        guard let url = calendarURL() else { return }

        Task {
            let json = await NetworkManager.GET(url)
            if let dict = json as? [String: Any] {
                self.parseDates(from: dict)
            } else {
                self.parseDates(from: [:])
            }
        }
    }

    private func calendarURL() -> URL? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        let now = Date()
        let maxDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 3)

        let city = UserDefaults.standard.string(forKey: "city")
        let calendarId = city == "1" ? seattleCalendarId : portlandCalendarId

        let urlString = "https://www.googleapis.com/calendar/v3/calendars/\(calendarId)/events?key=\(googleCalendarAPIKey)&singleEvents=true&orderBy=startTime&timeMin=\(timeFormatter.string(from: now))&timeMax=\(timeFormatter.string(from: maxDate))&timeZone=America/Los_Angeles&fields=items(id,start,summary,status,location,description)"

        return URL(string: urlString)
    }

    private func parseDates(from json: [String: Any]) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "EEE, MMM d"

        var events: [CalendarEvent] = []

        if let items = json["items"] as? [[String: Any]] {
            for entry in items {
                var event = CalendarEvent()
                event.title = entry["summary"] as? String ?? ""
                event.location = entry["location"] as? String ?? ""
                event.description = entry["description"] as? String ?? ""

                if let start = entry["start"] as? [String: Any] {
                    if let dateStr = start["date"] as? String,
                       let date = dayFormatter.date(from: dateStr) {
                        event.when = printDateFormatter.string(from: date)
                    } else if let dateTimeStr = start["dateTime"] as? String,
                              let date = timeFormatter.date(from: dateTimeStr) {
                        event.when = printDateFormatter.string(from: date)
                    } else {
                        event.when = "no date!"
                    }
                }

                events.append(event)
            }
        }

        dateList = events

        navigationItem.title = events.isEmpty ? "not found!" : "calendar"
        navigationItem.rightBarButtonItem = nil
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        dateList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dateList[section].when
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dateList[indexPath.section].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = dateList[indexPath.section]
        if !event.location.isEmpty {
            onEventSelected?(event)
        }
    }
}
