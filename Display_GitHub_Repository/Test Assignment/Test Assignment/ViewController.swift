//
//  ViewController.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    private let viewModel = ViewModel()
    private let activityIndiactor: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register our custom TableViewCell
        tableView.register(UINib(nibName: "RepositoryCell", bundle: .main), forCellReuseIdentifier: "RepositoryCell")
        // Slightly adjust the TableView
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 45.0, left: 0.0, bottom: 45.0, right: 0.0)

        setupActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Assign ourself as the ViewModel delegates
        viewModel.delegate = self
        // The GitHub User can here be exchanged to pretty much any user
        viewModel.getRepositories(for: "mralexgray")
    }

    // MARK: - Util
    private func setupActivityIndicator() {
        view.addSubview(activityIndiactor)
        activityIndiactor.center = view.center
        activityIndiactor.startAnimating()
    }
}

// MARK: - ViewModelProtocol
extension ViewController: ViewModelProtocol {
    func presentRepositories() {
        // Reload the Tableview once the response is persisted
        tableView.reloadData()
        activityIndiactor.stopAnimating()

        // Make the asyn call here for commits, after
        // the view is loaded and shown
        viewModel.getRepositoryCommits()
    }

    func presentCommit(for repository: String) {
        // Find the cell for the given repository name
        guard let cell = tableView.visibleCells.first(where: { tableViewCell -> Bool in
            guard let castedCell = tableViewCell as? RepositoryCell else {
                print("Failure, the cell is not of type 'RepositoryCell'")
                return false
            }

            return castedCell.nameLabel?.text == repository
        }) else { return }

        // Guard against the cell being a 'RepositoryCell'
        guard let repositoryCell = cell as? RepositoryCell else {
            print("Failure, the cell is not of type 'RepositoryCell'")
            return
        }

        // Find the indexPath of our Cell
        guard let indexPath = tableView.indexPath(for: repositoryCell) else { return }

        // Reload the Cell and set the SHA value
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Guard against index of our range
        guard viewModel.repositories?.indices.contains(indexPath.row) ?? false,
              let repository = viewModel.repositories?[indexPath.row] else {
            print("Failure, the indexPath is out of range")
            return UITableViewCell()
        }

        // Guard against the dequeued cell not being a RepositoryCell
        guard let repositoryCell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as? RepositoryCell else {
            print("Failure, the given cell can not be casted as 'RepositoryCell'")
            return UITableViewCell()
        }

        // Set all of the RepositoryCell's Outlets
        repositoryCell.nameLabel?.text = repository.name ?? "No Repository Title"
        repositoryCell.descriptionLabel?.text = repository.description ?? " - "
        repositoryCell.shaLabel?.text = "SHA: \(repository.commits?.sha ?? "")"
        repositoryCell.forksLabel?.text = "Forks: \(repository.forks ?? 0)"
        repositoryCell.languageLabel?.text = repository.language ?? " - "
        repositoryCell.watchersLabel?.text = "Watchers: \(repository.watchers ?? 0)"
        
        return repositoryCell
    }
}
