---
date: 2025-09-23 16:00
description: The official Vapor extension for Visual Studio Code is here!
tags: vapor, toolbox, templates, leaf, vscode
authors: Francesco
authorImageURLs: /author-images/francesco.jpg
---
# Meet Vapor for VS Code

Over the past six months, we have been working on [an extension](https://marketplace.visualstudio.com/items?itemName=Vapor.vapor-vscode) for VS Code to assist in the development of Vapor applications.
Let's explore its features and how it can enhance your development experience.

## Features

The extension offers a variety of features related to Vapor and Leaf.
It supports all platforms supported by Vapor, including macOS and Linux.
It can also be used with VS Code in the browser, but only for some Leaf-related features.

### Project Creation

You can create a new Vapor project directly from the Welcome page of VS Code or via the Command Palette.
Click on the `Create Vapor Project` button on the Welcome page or search for the `Vapor: Create New Project...` command in the Command Palette to get started.

By default, it will use [the standard template](https://github.com/vapor/template) provided by Vapor, but you can also choose a custom template by providing its URL in the extension settings.

It will prompt you to select a folder where the project will be created and its name, and then it will ask you for the variables defined in the template, such as the database driver to use and whether to include Leaf.

This feature requires the Vapor Toolbox to be installed on your machine. You can find installation instructions in the [Vapor Toolbox page](https://github.com/vapor/toolbox).

### Leaf Language Support

The extension defines the Leaf language in VS Code, adding Leaf file icons and such, and provides several features to assist in [Leaf](https://docs.vapor.codes/leaf/getting-started/) template development:

- **Syntax Highlighting**: Leaf files will have proper syntax highlighting for Leaf tags, added on top of existing HTML syntax highlighting. This makes it easier to read and write HTML templates, even when working with CSS and JavaScript with Leaf tags embedded in them. This feature is available both in local and browser-based VS Code.
- **Formatter**: You can format your Leaf files using the `Format Document` command in VS Code. This will ensure that your templates are consistent, with the proper indentation and spacing for both Leaf and HTML tags. You can also format just a selected portion of the file using the `Format Selection` command and enable the `Format on Save` option in VS Code settings.
- **Emmet Support**: The extension supports [Emmet](https://code.visualstudio.com/docs/languages/emmet) abbreviations and snippets in Leaf files, allowing you to quickly generate HTML structures.

### Snippets

The extension includes a collection of snippets for common Vapor and Leaf constructs, such as Vapor endpoints and middleware in Swift files, and default tags and control flow statements in Leaf files.

Snippets will appear as IntelliSense suggestions as you type a snippet prefix, or you can search for them using the `Insert Snippet` command in the Command Palette.

## Wrapping Up

The "Vapor for VS Code" extension is available on the Visual Studio Code Marketplace.
You can find its source code on [GitHub](https://github.com/vapor-community/vapor-vscode).

If you have any feedback or suggestions for new features, please open an issue on the GitHub repository or reach out to us on the [Vapor Discord](https://vapor.team/).

We hope this extension will make your Vapor and Leaf development experience on Visual Studio Code the best it can be!
