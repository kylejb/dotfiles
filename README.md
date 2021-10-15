# Dotfiles for GitHub's Codespaces

Any changes to dotfiles repository will apply only to each new codespace, and do not affect any existing codespace.


> **Note**: Currently, Codespaces does not support personalizing the User settings for the Visual Studio Code editor with your dotfiles repository. You can set default *Workspace and Remote [Codespaces]* settings for a specific project in the project's repository. For more information, see "[Configuring Codespaces for your project](https://docs.github.com/en/github/developing-online-with-codespaces/configuring-codespaces-for-your-project#creating-a-custom-codespace-configuration)." - [source](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account)

## Installation

When creating a new codespace, this repository would be cloned into your container. GitHub will syslink any files or folders in repository that start with `.` to codespace's `$HOME` directory **IF** one of the following cannot be found:

- <span>install.sh</span>
- <span>install</span>
- <span>bootstrap.sh</span>
- <span>bootstrap</span>
- <span>script/bootstrap</span>
- <span>setup.sh</span>
- <span>setup</span>
- <span>script/setup</span>
