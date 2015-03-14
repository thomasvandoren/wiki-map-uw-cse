## Table of Contents ##

  * [Developer Notes](#Developer_Notes.md)
    * [Setting Up Your Account on Cubist](#Setting_Up_Your_Account_on_Cubist.md)
    * [Cloning the Repos](#Cloning_the_Repos.md)
    * [Pushing](#Pushing.md)
    * [Branches](#Branches.md)
    * [Environment Setup](#Environment_Setup.md)
    * [Build and Deploy WikiGraph](#Build_and_Deploy_WikiGraph.md)
    * [Configuring Cubist Shared Directory](#Configuring_Cubist_Shared_Directory.md)

# Developer Notes #

The goal of this page is to help developers setup their environments and work with third-party applications. Please update this content as you discover caveats and improvements.

## Setting Up Your Account on Cubist ##

The shared directory where all the deployed products, tools, etc live:

`/projects/instr/cubist/11wi/cse403/WikiMap-M`

Your default umask does not allow group write permission. Please update your umask on cubist to allow group write permissions by default. Here's how:
  1. ssh into cubist
  1. Open ~/.bash\_profile
  1. Add the following line
```
umask 0002
```
  1. Save .bash\_profile
  1. You will have to logout and log back in for the new permissions to work

See ToolsAndDocs for links to CSE support docs.

## Cloning the Repos ##

To clone main repo:
```
hg clone https://wiki-map-uw-cse.googlecode.com/hg/ wiki-map-uw-cse
```

NOTE: the cloning action takes a long time and it shows no progress indicator, so be patient. It took me ~5min to clone on a home broadband (wired) connection. It will let you know if it fails.

You need to add a username so that your commits are appropriately authored. From your repo directory (i.e. wiki-map-uw-cse in the example above). Open .hg/hgrc in a text editor and add the following to the bottom:

```
[ui]
username = Your Name <youremail@gmail.com>
```

Then switch to the `dev` branch:
```
hg checkout dev
```

You will have to login with your full gmail address and your [Google code password](https://code.google.com/hosting/settings) in order to push changes to remote repository

## Pushing ##

This is an open source project. As such, its repository is publicly accessible.

Do **NOT** commit anything that contains passwords or any private information!

If you mistakenly commit & push something that should not be publicly accessible to the remote repo, please let Thomas know immediately. It may require the entire source repo be deleted and replayed (using a local copy).

If it is just a local commit, you can remove it from your local history (and it will never see the public repos).

Before you push, make sure you pull or update.

To commit changes, you will need to

  1. Add the files that have changed
    * This, unlike subversion, add the current state of the file to the repository
```
hg add <file-name>
```
  1. Commit the changes to your local repository
    * As you work on a project, you should commit as you complete tasks.
    * Make sure that your code compiles and is clean, then commit.
    * These changes will **not** be visible to the main repository until you `push` them
    * Multiple commits may be pushed to the central repo at once
```
hg commit -m "Add a useful message!"
```
  1. Push the changes to the remote (Google Code) repository
    * Make sure you `hg pull` **before** you `push`
```
hg pull
hg push
```

## Branches ##

There are three branches in the repo.

  1. **dev** -- this branch is the default branch; all your commits should be to this branch.
  1. **release** -- this branch will contain our major releases; we will merge the dev branch into release for our three major releases
    * This will allow us to make changes specific to the release
    * For example, in the alpha release we can take out features that are under development, but that do not yet work. They will stay 'alive' in the dev branch so that work can progress as usual.
  1. **default** -- we probably won't use this one
  1. (optional/contingency) **hotfix-x.x** -- we can create a 'hotfix' branch if we need to patch one of our releases, but don't have dev in a stable state. Hopefully we can avoid this :-)

## Environment Setup ##

See the ToolsAndDocs page for lots of links to documentation and installation instructions. If you encounter difficulties with installation or while working with a tool or environment, please post problems/solutions to the ToolsAndDocs page. You may save the next developer some hassle!

## Build and Deploy WikiGraph ##

  * [BuildAndTestNotes](BuildAndTestNotes.md) - information about building the services, database, or client locally. It also includes information about testing, Hudson configuration, and dependencies
  * [DeployNotes](DeployNotes.md) - information about deploying WikiGraph packages

## Configuring Cubist Shared Directory ##

`/projects/instr/cubist/11wi/cse403/WikiMap-M`

We would like to keep everything in our shared cubist space group accessible. To achieve this, the following was done to our directory:
```
cd WikiMap-M
chgrp -RH cse403f .
find . -type d -exec chmod g+s {} \;
```

This should, by default, add cse403f as the default group for files you create (instead of your primary group). To change the group of a specific file:
```
chgrp cse403f <filename>
```