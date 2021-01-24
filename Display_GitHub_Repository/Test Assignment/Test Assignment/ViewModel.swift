//
//  ViewModel.swift
//  Test Assignment
//
//  Created by Johannes Grün on 24.01.21.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    func presentRepositories()
    func presentCommit(for repository: String)
}

final class ViewModel {
    var repositories: [Repository]?
    weak var delegate: ViewModelProtocol?

    private enum Constants {
        static let repository = "https://api.github.com/users/"
        static let commits = "https://api.github.com/repos/"
    }
    
    /// Requests all repositories for a given user
    func getRepositories(for user: String) {
        // "https://api.github.com/users/#USER#/repos"
        guard let repositoryURL = URL(string: Constants.repository + user + "/repos") else {
            return
        }

        // Make the repository request
        NetworkUtil.shared.fetchRepository(url: repositoryURL) { [weak self] repositories in
            // Persist the fetched repositories
            self?.repositories = repositories
            
            // Via delegate signal to present the repositories
            self?.delegate?.presentRepositories()
        }
    }
    
    /// Requests the last commit for each listed repository
    func getRepositoryCommits() {
        var repositoryAndCommitURL: [(repository: String, url: URL?)] = []

        // Construct the commit url based on the repository
        repositories?.forEach({ repository in
            if let owner = repository.owner?.name,
               let repositoryName = repository.name {

                let url = constructCommitURL(from: owner, with: repositoryName)
                repositoryAndCommitURL.append((repositoryName, url))
            }
        })

        // Dispatch the following task into background
        DispatchQueue.global(qos: .userInitiated).async {
            // Create a dispatch queue for all commit requests
            let dispatchGroup = DispatchGroup()

            // Iterate over all unwrapped repository commit urls
            for case let (repositoryName, commitURL?) in repositoryAndCommitURL {
                // Enter dispatch group
                dispatchGroup.enter()

                // Make the commit requests
                NetworkUtil.shared.fetchCommit(with: commitURL) { [weak self] commits in

                    guard let lastCommit = commits.last else { return }

                    // Return to the main thread
                    DispatchQueue.main.async {
                        // Update our data source with the new commit
                        self?.repositories?.first(where: { $0.name == repositoryName })?.commits = lastCommit
                        // Call the delegate from inside the closure
                        self?.delegate?.presentCommit(for: repositoryName)
                        // Leave the dispatch group, after work is done
                        dispatchGroup.leave()
                    }
                }
            }
            // Wait until dispatch group is empty
            dispatchGroup.wait()
        }
    }
    
    /// Construct the URL for a specific users repository
    /// - Parameters:
    ///   - user: Github user
    ///   - repository: Github repository
    /// - Returns: Optional URL
    private func constructCommitURL(from user: String, with repository: String) -> URL? {
        /// "https://api.github.com/repos/#USER#/#REPOSITORY#/commits"
        return URL(string: Constants.commits + user + "/" + repository + "/commits")
    }
}
