# urban_git_task
# Urban Match Flutter Assignment
# Task 1: Connect to the Github API to retrieve the list of public repositories in your Github Account.
## Approach to solve: 
  This Flutter code defines a ViewModel (GitHubRepoViewModel) for fetching and displaying GitHub repositories. It utilizes the Dio package for making HTTP requests 
  and the flutter_dotenv package for managing API keys.
  1. The ViewModel includes a GitHub API token retrieved from a .env file using flutter_dotenv
  2. Repositories are fetched in pages using Pagenation, with a specified page size. The ViewModel maintains a currentPage variable to keep track of the current page.
  3. The fetchRepos method is responsible for fetching repositories from the GitHub API. It handles success and error responses, including handling rate limit errors.
  4. The fetched Repositories are shown in different clickable cards which show repo name, description fetched from first API and card contains a last Commit Date 
     which is fetched from secpnd API.
# Task 2: Once the list has been populated, start retrieving information about the last commit for each repository.     
## Approach to solve:
  Once cards showing repo details are loaded on UI screen they can be clicked and the user is navigated to the next page where the details of last commit are shown.
  1. The code asynchronously fetches repositories and commits, ensuring a smooth user experience.
  2. After fetching repositories, the ViewModel asynchronously fetches the last commit information for each repository.
  3. The commit_page.dart shows the last commit details specific to the card being clicked.
  4. This page shows repo name, last commit SHA, last commit message.
The code includes error handling for various scenarios, such as non-200 status codes and rate limit exceeded errors.
# Video Preview:
  Google drive link :[https://drive.google.com/file/d/1sWvskcUfUwnIOaD9MyggIad-xsdhDbIo/view?usp=drive_link]
# Installation:
  Google drive link:[https://drive.google.com/file/d/1cHPnevdiGKABoY9vwkrG0C-1cbNwHQKJ/view?usp=drive_link]
  
