# jira-release-notes-action
This GitHub Action gets a list of closed issues for a specific version and project in Jira.

# Example Workflow
```yaml
name: Get a release notes

on: push

jobs:
  build-number:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Release notes
      id: action
      uses: modestman/jira-release-notes-action@master
      env:
        JIRA_BASE_URL: ${{ secrets.JIRA_BASE_URL }}
        JIRA_USER_EMAIL: ${{ secrets.JIRA_USER_EMAIL }}
        JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      with:
        projects: 'FRNT,PAYMNT,CARD'
        version: 'iOS-next'

    - name: Print output
      # Use the output from the `action` step
      run: |
        echo "${{ steps.action.outputs.release_notes }}"
```

# Variables

Next variables needs to be set in the `Secrets` section of your repository options.
* `JIRA_BASE_URL`
* `JIRA_USER_EMAIL`
* `JIRA_API_TOKEN`

### Input

* **projects**: The list of project identifiers. One line separated by commas (example: `FRNT,PAYMNT,CARD`).
* **version**: The fix version. Must be created in Jira releases

### Output

You can get release notes from action output by id `release_notes`, see example above.