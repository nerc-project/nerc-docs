# Contribution guide

This guide outlines how to contribute to this project and standards which should be observed when adding to this repository. This repository contains NERC technical documentation written in Markdown which is converted to html/css/js with the [mkdocs](http://www.mkdocs.org) static site generator. The theme is based on [mkdocs-material](https://github.com/squidfunk/mkdocs-material) with NERC customizations for layout and design.

### Cloning repository

To get started you can **clone** the repository, however it's recommended to create a fork and clone your fork.

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

## NERC Staff