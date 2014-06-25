This repo is intended to provide a quick, easy virtual environment to develop the SCOOP Query Engine and SCOOP Visualizer.

### Getting Started:

```bash
git clone https://github.com/Hoverbear/vm.git --recursive
cd vm
vagrant up # First start will take awhile.
```
This will provide you with the latest stable setup. If you want the latest and buggiest, switch the submodules to `master` branches.

### Updating a Module
```bash
cd $MODULE
git branch # Note how you're on a detached head.
git checkout master # Important: Change to master

# Make edits

git commit -a -m "My Changes"
git push
cd .. # Back to project root
git commit -a -m "Bumped $MODULE"
```
