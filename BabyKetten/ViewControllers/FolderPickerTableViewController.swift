import UIKit

class FolderPickerTableViewController: UITableViewController {
    var folderList: [String] = []
    var selectedFolder: IndexPath?

    var onFolderPicked: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Choose Folder"
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    }

    @objc private func doneAction() {
        if let selectedFolder {
            let folderName = selectedFolder.row == 0
                ? FavoritesRootFolder.name
                : folderList[selectedFolder.row]
            onFolderPicked?(folderName)
        }
        dismiss(animated: true)
    }

    @objc private func cancelAction() {
        onFolderPicked?(nil)
        dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folderList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FolderPickerCell")
        let title = folderList[indexPath.row]

        cell.textLabel?.text = indexPath.row == 0 ? title : "📁 \(title)"
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let previous = selectedFolder {
            tableView.cellForRow(at: previous)?.accessoryType = .none
        }
        selectedFolder = indexPath
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
