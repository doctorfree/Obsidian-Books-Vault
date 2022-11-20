# Release Notes

## Table of contents

1. [Overview](#overview)
1. [Installation](#installation)
1. [Configuration](#configuration)
1. [Removal](#removal)
1. [Support](#support)
1. [Changelog](#changelog)

## Overview

The Obsidian Books Vault is an [Obsidian](https://obsidian.md) vault containing book descriptions in markdown format. It can be viewed using any markdown viewer (e.g. almost any browser) but if Obsidian is used then many additional features will be available including queries using the [Dataview](https://blacksmithgu.github.io/obsidian-dataview/) plugin for [Obsidian](https://obsidian.md/).

The `Obsidian-Books-Vault` repository reflects the partial contents of my personal library of books, cds, and records. As such, it may be relevant only to a few. However, the process by which this repository was created and curated as well as the tools used in its creation and curation may be useful to a wider audience. I am making it public and freely licensed so that others may examine, adapt, clone, and use in whatever manner they choose. See the [description of Process](Process.md) for an overview of the process and tools employed in the creation of this repository.

These are the release notes for Version 1.0.1 Release 1 of the Obsidian Books Vault.

## Installation

The Obsidian Books Vault can be installed on Windows, Mac, or Linux. The following installation instructions are for Mac and Linux. Windows users can follow similar steps.

**For the optimal experience, open this vault in Obsidian!**

1. [Download the vault](https://github.com/doctorfree/Obsidian-Books-Vault/releases/latest)
3. Open the vault in Obsidian via "Open another vault -> Open folder as vault"
4. Trust us. :) 
5. When Obsidian opens the settings, verify that the "Dataview", "Excalidraw", and "Excalibrain" plugins are enabled
6. Done! The Obsidian Books Vault is now available to you in its purest and most useful form!

### Download the release archive

[Download the latest release](https://github.com/doctorfree/Obsidian-Books-Vault/releases/latest).

Those familiar with `wget` can download this release from the command line with:

```shell
wget --quiet -O ~/Downloads/Obsidian-Books-Vault-v1.0.1r1.tar.gz \
  https://github.com/doctorfree/Obsidian-Books-Vault/archive/refs/tags/v1.0.1r1.tar.gz
```

### Extract the release archive

Currently release archives are available in either ZIP or compressed tar archive format.

To extract the ZIP archive:

```shell
cd /path/to/your/vaults # e.g. `cd ~/Documents/Obsidian`
unzip /path/to/Obsidian-Books-Vault-1.0.1r1.zip
```

To extract the compressed tar archive:

```shell
cd /path/to/your/vaults # e.g. `cd ~/Documents`
tar xf /path/to/Obsidian-Books-Vault-1.0.1r1.tar.gz
```

Once extracted, the Obsidian Books Vault is now available in `/path/to/your/vaults/Obsidian-Books-Vault-1.0.1r1/`.

The downloaded archive can be deleted:

```shell
rm -f /path/to/Obsidian-Books-Vault-1.0.1r1.zip
```

or

```shell
rm -f /path/to/Obsidian-Books-Vault-1.0.1r1.tar.gz
```

## Configuration

The Obsidian Books Vault is pre-configured for use with [Obsidian](https://obsidian.md). Install Obsidian for your platform by clicking the appropriate installation link at the Obsidian website. Obsidian is available for Windows, Mac, and Linux as well as mobile devices.

Add a new vault in Obsidian with `Open folder as vault` and navigate to the `Obsidian-Books-Vault-1.0.1r1` extracted folder. When prompted, `Trust` and enable the `Dataview` plugin if it is not already enabled.

The Obsidian Books Vault includes the `Doctorfree` Obsidian theme. Enable this Obsidian theme in Obsidian by visiting `Settings -> Appearance` and selecting `Doctorfree` from the dropdown in the `Themes` section.

Obsidian is required for some features but is not necessary to view the Obsidian Books Vault. Any markdown viewer/editor can be used. If the Obsidian Books Vault is extracted into a website folder, it can be viewed using most browsers.

### Book Queries

The Obsidian Books Vault has been curated with metadata allowing queries to be performed using the Obsidian Dataview plugin. Sample queries along with the code used to perform them can be viewed in the [Books Queries](Books_Queries.md) document.

## Removal

To remove the Obsidian Books Vault simply remove the extracted folder and its contents:

```shell
cd /path/to/your/vaults # e.g. `cd ~/Documents/Obsidian`
rm -rf Obsidian-Books-Vault-1.0.1r1
```

## Support

Support the development and improvement of the Obsidian Books Vault by [sponsoring the Projects of Doctorfree](https://github.com/sponsors/doctorfree).

<a href="https://www.buymeacoffee.com/doctorfree"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=doctorfree&button_colour=5F7FFF&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00"></a>

## Changelog

View the full changelog for this release at https://github.com/doctorfree/Obsidian-Books-Vault/blob/v1.0.1r1/CHANGELOG.md
