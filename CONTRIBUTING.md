# Contribution guide

This guide outlines how to contribute to this project and standards which should be observed when adding to this repository. This repository contains NERC technical documentation written in Markdown which is converted to html/css/js with the [mkdocs](http://www.mkdocs.org) static site generator. The theme is based on [mkdocs-material](https://github.com/squidfunk/mkdocs-material) with NERC customizations for layout and design.

## How to Contribute
Never made an open-source contribution before? Wondering how contributions work in this project? Here's a quick rundown!

### Finding or adding issues

Find an issue that you are interested in addressing or a feature that you would like to add in the [issue tracker](https://github.com/nerc-project/nerc-docs/issues). Don't see your issue? Submit one!

### Forking and Cloning repository

To get started, you can fork the repository associated with the issue to your local GitHub account. This means that you will have a copy of the repository under your-GitHub-username/repository-name.

Clone the repository to your local machine.
```
# SSH method
git clone git@github.com:nerc-project/nerc-docs.git

# HTTP method
git clone https://github.com/nerc-project/nerc-docs.git
```

You will need to install some dependencies in order to build documentation locally. This example uses a Python3 virtual environment, but you are free to choose any other method to create a local virtual environment like Conda.
```
cd nerc-docs
py -3 -m venv venv
```
Activate the virtual environment by running:

  **on Linux/Mac**:

    source venv/bin/activate
  
  **on Windows**: 
  
    venv\Scripts\activate

Once virtual environment is activated, install dependencies listed in `requirements.txt` file running:
```
pip install -r requirements.txt
```

### Edit with live preview

Open a terminal session with the appropriate conda environment activated, navigate to the root directory of the repository (where `mkdocs.yml` is located) and run the command `mkdocs serve`. This will start a live-reloading local web server. You can then open [http://127.0.0.1:8000](http://127.0.0.1:8000) in a web browser to see your local copy of the site.

In another terminal (or with a GUI editor) edit existing files, add new pages to `mkdocs.yml`, etc. As you save your changes the local web serve will automatically re-render and reload the site.

### Output a static site

To build a self-contained directory containing the full html/css/js of the site:
```
mkdocs build
```

## Typical workflow

The user workflow can be described in the following steps assuming you are using upstream repo.

Please make sure you sync your `main` branch prior to creating a branch from `main`.
```
git checkout main
git checkout -b <BRANCH>
git add <file1> <file2> ...
git commit -m <COMMIT MESSAGE>
git push origin <BRANCH>
```

Next create a merge request to the `main` branch with your newly created branch.

## Merge Requests
Title the pull request with a short description of the changes made and the issue or bug number associated with your change. For example, you can title an issue like so "WIP: Fixed spelling mistake to resolve #100".

In the description of the pull request, explain the changes that you made, any issues you think exist with the pull request you made, and any questions you have for the maintainer. It's OK if your pull request is not perfect (no pull request is), the reviewer will be able to help you fix any problems and improve it!

Wait for the pull request to be reviewed by a maintainer.

Make changes to the pull request if the reviewing maintainer recommends them.

Celebrate your success after your pull request is merged!

## Getting Help
If you need help, you can ask questions on the [issue tracker](https://github.com/nerc-project/nerc-docs/issues).

## NERC Staff